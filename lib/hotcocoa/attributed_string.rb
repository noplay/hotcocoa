module HotCocoa
  class NSRangedProxyAttributeHash
    ATTRIBUTE_KEYS = { :font => NSFontAttributeName,
                       :paragraph_style => NSParagraphStyleAttributeName,
                       :color => NSForegroundColorAttributeName,
                       :underline_style => NSUnderlineStyleAttributeName,
                       :superscript => NSSuperscriptAttributeName,
                       :background_color => NSBackgroundColorAttributeName,
                       :attachment => NSAttachmentAttributeName,
                       :ligature => NSLigatureAttributeName,
                       :baseline_offset => NSBaselineOffsetAttributeName,
                       :kerning => NSKernAttributeName,
                       :link => NSLinkAttributeName,
                       :stroke_width => NSStrokeWidthAttributeName,
                       :stroke_color => NSStrokeColorAttributeName,
                       :underline_color => NSUnderlineColorAttributeName,
                       :strikethrough_style => NSStrikethroughStyleAttributeName,
                       :strikethrough_color => NSStrikethroughColorAttributeName,
                       :shadow => NSShadowAttributeName,
                       :obliqueness => NSObliquenessAttributeName,
                       :expansion_factor => NSExpansionAttributeName,
                       :cursor => NSCursorAttributeName,
                       :tool_tip => NSToolTipAttributeName,
                       :character_shape => NSCharacterShapeAttributeName,
                       :glyph_info => NSGlyphInfoAttributeName,
                       :marked_clause_segment => NSMarkedClauseSegmentAttributeName,
                       :spelling_state => NSSpellingStateAttributeName }


    def initialize(proxy)
      @proxy = proxy
    end

    def [](k)
      k = attribute_for_key(k)
      @proxy.string.attribute(k, atIndex:@proxy.range.first, effectiveRange:nil)
    end

    def []=(k,v)
      k = attribute_for_key(k)
      @proxy.string.removeAttribute(k, range:@proxy.range.to_NSRange(@proxy.string.length - 1))
      @proxy.string.addAttribute(k, value:v, range:@proxy.range.to_NSRange(@proxy.string.length - 1))
    end

    def <<(attributes)
      attributes.each_pair do |k, v|
        self[k] = v
      end
      self
    end
    alias :merge :<<

    def to_hash
      @proxy.string.attributesAtIndex(@proxy.range.first, effectiveRange:nil).inject({}) do |h, pair|
        h[key_for_attribute(pair.first)] = pair.last
        h
      end
    end

    def inspect
      to_hash.inspect
    end

    private

    def key_for_attribute(attribute)
      (ATTRIBUTE_KEYS.select { |k,v| v == attribute }.first || [attribute]).first
    end

    def attribute_for_key(key)
      ATTRIBUTE_KEYS[key] || key
    end
  end

  class NSRangedProxyAttributedString
    attr_reader :string, :range

    def initialize(string, range)
      @string = string
      @range = range
    end

    def attributes
      NSRangedProxyAttributeHash.new(self)
    end
  end
end

  end

  end

  end

  end

  end

  end

  end
end
