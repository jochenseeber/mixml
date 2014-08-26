require 'ae'
require 'equivalent-xml'
require 'nokogiri'

# Save the following block as XML
When /\buse\b[^.]+\bXML in (?:file )?`([a-z]+\.xml)`/i do |file_name, xml|
    raise(ArgumentError, 'Please supply a block with XML.') if xml.nil?

    doc = Nokogiri::XML(xml) do |config|
        config.default_xml.noblanks
    end

    File.open(file_name, 'w') do |f|
        doc.write_xml_to(f, :indent => 4)
    end
end

# Expect the following block as XML in a file
When /\bproduces\b[^.]+\bXML in (?:file )?`([a-z]+\.xml)`/i do |file_name, xml|
    raise(ArgumentError, 'Please supply a block with the XML document.') if xml.nil?

    actual = Nokogiri::XML(File.read('test.xml')) do |config|
        config.default_xml.noblanks
    end

    expected = Nokogiri::XML(xml) do |config|
        config.default_xml.noblanks
    end

    EquivalentXml.assert.equivalent?(actual, expected, :element_order => true)
end

# Expect the following block as XML output
When /\bproduces\b[^.]+\bXML output\b/i do |xml|
    raise(ArgumentError, 'Please supply a block with the XML document') if xml.nil?

    actual = Nokogiri::XML(@output) do |config|
        config.default_xml.noblanks
    end

    expected = Nokogiri::XML(xml) do |config|
        config.default_xml.noblanks
    end

    options = {:element_order => true}
    EquivalentXml.assert.equivalent?(actual, expected, options)
end
