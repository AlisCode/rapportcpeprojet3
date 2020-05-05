import os
import hashlib
import subprocess as sp
import panflute as pf
from shutil import which


class SvgbobInline(object):
    """
    Converts Code Block with svgbob class to svg Image
    requires `svgbob` in PATH
    option can be provided as attributes or can set default values in yaml metadata block
    option          | metadata              | default
    ----------------|-----------------------|----------
    font-family     | svgbob.font-family    | "Arial"
    font-size       | svgbob.font-size      | 14
    scale           | svgbob.scale          | 1
    stroke_width    | svgbob.stroke-width   | 2
    caption         | svgbob.caption        | ""
    """

    def __init__(self):
        self.dir_to = "svg"
        assert which("svgbob"), "svgbob is not in path"

    def action(self, elem, doc):
        if isinstance(elem, pf.CodeBlock) and "svgbob" in elem.classes:
            options = elem.attributes
            pf.debug(elem.text);

            meta_font_family = doc.get_metadata("svgbob.font-family", "noto")
            meta_font_size = doc.get_metadata("svgbob.font-size", 14)
            meta_scale = doc.get_metadata("svgbob.scale", 1)
            meta_stroke_width = doc.get_metadata("svgbob.stroke-width", 2)
            meta_caption = doc.get_metadata("svgbob.caption", "")

            font_family = options.get("font-family", meta_font_family)
            font_size = options.get("font-size", meta_font_size)
            scale = options.get("scale", meta_scale)
            stroke_width = options.get("stroke-width", meta_stroke_width)
            caption = options.get("caption", meta_caption);
            svgbob_option = " ".join([
                '--font-family "{}"'.format(font_family) if font_family is not None else "",
                "--font-size {}".format(font_size) if font_size is not None else "",
                "--scale {}".format(scale) if scale is not None else "",
                "--stroke-width {}".format(stroke_width) if stroke_width is not None else "",
            ])

            counter = hashlib.sha1(elem.text.encode("utf-8")).hexdigest()[:8]
            linktofile = "./out/{}".format(counter)
            linktofile_png = "./out/{}.png".format(counter)
            link = "out/{}".format(counter);
            link_png = "out/{}".format(counter);
            linkto_txt = "{}.txt".format(linktofile)
            with open(linkto_txt, 'w') as f:
                f.write(elem.text);
            command = "svgbob {} {} -o {}".format(svgbob_option, linkto_txt, linktofile)
            sp.Popen(command, shell=True, stdin=sp.PIPE, stdout=sp.PIPE, stderr=sp.PIPE)
            command = "rsvg-convert {} -o {}".format(linktofile, linktofile_png)
            sp.Popen(command, shell=True, stdin=sp.PIPE, stdout=sp.PIPE, stderr=sp.PIPE)
            elem.classes.remove("svgbob")
            #elem = pf.base.Block(pf.Image(*caption, classes=elem.classes, url=link,
            #               identifier=elem.identifier, title="fig:", attributes=elem.attributes))
            final_block = "\\begin{figure}\\includegraphics{" + link_png + "}\\end{figure}"
            #final_block = "\\begin{figure}\\includegraphics{out/4ffb0af9.png}\\end{figure}"
            elem = pf.RawBlock(final_block, format="latex");
            return elem

def main(doc=None):
    si = SvgbobInline()
    pf.run_filters([si.action], doc=doc)
    return doc


if __name__ == "__main__":
    main()
