return {
    {
        CodeBlock = function(elem) 
            if elem.classes[1] == "svgbob" then 
                local img = pandoc.pipe("svgbob", {"--font-family", "noto"}, elem.text);	
	 	os.execute("svgbob --font-family noto");	
		print(img);
		local img_raster = pandoc.pipe("rsvg-convert", {}, img);
		print(img_raster);
                --local img = pandoc.pipe("svgbob", {"--font-family", "arial"}, elem.text);
                local filename = pandoc.sha1(elem.text) .. ".png";
                local schema_name = elem.attributes["name"] or 'Schema';
                schema_name_str = pandoc.Span(schema_name);
                --pandoc.mediabag.insert(filename, "image/png", img_raster);
                --pandoc.mediabag.insert(filename, "image/svg", img);
                local w = elem.attributes["width"] or "100%";
                local attrs = pandoc.Attr("", {}, {{"width", w}})
                --return pandoc.Para { 
                --    pandoc.Image({ schema_name_str }, filename, schema_name, attrs), 
                --}
		return { pandoc.RawBlock('latex', '\\begin{figure}\\includesvg{' .. filename .. '}\end{figure}') };
            end
        end
    }
}
