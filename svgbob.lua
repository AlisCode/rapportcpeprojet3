return {
    {
        CodeBlock = function(elem) 
            if elem.classes[1] == "svgbob" then 
                local img = pandoc.pipe("svgbob", {"--font-family", "monospace"}, elem.text);
                local filename = pandoc.sha1(img) .. ".svg";
                local schema_name = elem.attributes["name"] or 'Schema';
                schema_name_str = pandoc.Span(schema_name);
                pandoc.mediabag.insert(filename, "image/svg", img);
                local w = elem.attributes["width"] or "100%";
                local attrs = pandoc.Attr("", {}, {{"width", w}})
                return pandoc.Para { 
                    pandoc.Image({ schema_name_str }, filename, schema_name, attrs), 
                }
            end
        end
    }
}