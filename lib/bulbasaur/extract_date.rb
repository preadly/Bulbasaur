require_relative '../../../lib/extra_chron'

module Operations
  class ExtractDate
    FALLBACK_DATE_SELECTORS ||= %w(
      .time .date .headline-time .date-header
    )

    def initialize(doc, crawler, lang)
      @doc = doc
      @crawler = crawler
      @lang = lang
    end

    def call
      proxy = TagProxy.new(nil, @crawler, @lang, @doc)
      date = proxy.filter_date_by_og
      return proxy.turn_to_utc(date) unless date.nil?
      
      tag = date_tag

      if tag.name == "time"
        TimeTagProxy.new tag
      else
        TagProxy.new tag, @crawler, @lang, @doc
      end.to_time
    rescue => e
      raise if e.is_a? Failed
      raise Failed.new(e)
    end

    private

    def date_tag
      selectors.each do |selector|
        if selector =~ /\:last-child/
          return @doc.css(selector.gsub(/\:last-child/, "")).last
        else
          nodes = @doc.css selector
          return nodes.first if nodes.first
        end
      end
      fail DateNotFound
    end

    def selectors
      if @crawler.date_selector.present?
        [@crawler.date_selector]
      else
        FALLBACK_DATE_SELECTORS
      end
    end

    TimeTagProxy ||= ::Struct.new(:tag) do
      def call
        Time.parse tag.attributes["datetime"].value
      end
      alias_method :to_time, :call
    end

    TagProxy ||= ::Struct.new(:tag, :crawler, :lang, :doc) do
      def call
        date_string = tag.inner_text.strip
        date_string = filter_children tag, date_string
        date_string.gsub! /\n|\r|\t/, " "

        filter_date_by_url

        date = filter_date date_string

        if date.nil?
          if @day.nil? or @month.nil? or @year.nil?
            raise DateFailed.new("Day, month or year is nil")
          end

          date = "#{@day}/#{@month}/#{@year}"
        end

        date += filter_time date_string
        turn_to_utc date
      end
      alias_method :to_time, :call

      def filter_date_by_url
        if crawler.accept_pattern.present? and not doc.request_uri.nil?
          pattern = ::Regexp.new crawler.accept_pattern
          matches = uri.match pattern

          if matches
            @day = matches[:day] if matches.names.include? ("day")
            @month = matches[:month] if matches.names.include? ("month")
            @year = matches[:year] if matches.names.include? ("year")
          end
        end
      end

      def filter_date_by_og
        metas = doc.html.css('meta')

        date_meta = metas.detect do |meta|
          meta.attributes.include?('property') and
          (
            meta.attributes['property'].value == 'og:updated_time' or
            meta.attributes['property'].value == 'article:modified_time' or
            meta.attributes['property'].value == 'article:published_time'
          )
        end

        return nil if date_meta.nil?
        date_meta.attributes['content'].value
      end

      def turn_to_utc(date)
        ExtraChron.parse(
          date,
          pattern: crawler.date_pattern,
          lang: lang
        )
      end

      def filter_children(date_tag, date_string)
        unless !!(date_string =~ /(\s|-|\/)/)
          unless date_tag.children.empty?
            return date_tag.children.map(&:inner_text).join " "
          end
        end

        date_string
      end

      def filter_date(date_string)

        if crawler.date_pattern.present?
          pattern = ::Regexp.new crawler.date_pattern
          matches = date_string.match pattern

          if matches
            @day = matches[:day] if matches.names.include? ("day") and not @day.present?
            @month = matches[:month] if matches.names.include? ("month") and not @month.present?
            @year = matches[:year] if matches.names.include? ("year") and not @year.present?
            nil
          end
        else
          date_string
        end
      rescue => e
        raise DateFailed.new(e)
      end

      def filter_time(date_string)
        if crawler.time_pattern.present?
          pattern = ::Regexp.new crawler.time_pattern
          matches = date_string.match pattern
          " #{matches[:hours]}\:#{matches[:minutes]}"
        end || ""
      rescue => e
        raise TimeFailed.new(e)
      end
    end

    class Failed < ::StandardError
      def initialize(original_exception = nil)
        super
        @original_exception = original_exception
      end

      def message
        if @original_exception == self
          super
        elsif @original_exception
          @original_exception.message
        end
      end

      def backtrace
        if @original_exception == self
          super
        elsif @original_exception
          @original_exception.backtrace
        end
      end
    end
    DateFailed   ||= ::Class.new(Failed)
    DateNotFound ||= ::Class.new(Failed)
    TimeFailed   ||= ::Class.new(Failed)
  end
end
