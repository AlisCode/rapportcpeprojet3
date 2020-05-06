return {
    {
        CodeBlock = function(elem) 
            if elem.classes[1] == "svgbob" then 
                local img = pandoc.pipe("svgbob", {"--font-family", "monospace"}, elem.text);	
                local filename = pandoc.sha1(elem.text) .. ".svg";
                local schema_name = elem.attributes["name"] or 'Schema';
                schema_name_str = pandoc.Span(schema_name);
                --pandoc.mediabag.insert(filename, "image/png", img_raster);
                pandoc.mediabag.insert(filename, "image/svg+xml", img);
                local w = elem.attributes["width"] or "100%";
                local attrs = pandoc.Attr("", {}, {{"width", w}})
                --return pandoc.Para { 
                --    pandoc.Image({ schema_name_str }, filename, schema_name, attrs), 
                --}
		return { 
			pandoc.RawBlock('latex', '\\begin{figure}'),
			pandoc.Para { pandoc.Image({ schema_name_str }, filename, schema_name, attrs) },
			pandoc.RawBlock('latex', '\\caption{'.. schema_name ..'}'),
			pandoc.RawBlock('latex', '\\end{figure}') 
		};
		--return { pandoc.Div(
            end
        end
    }
}
