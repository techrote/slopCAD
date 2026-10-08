#!/usr/bin/env python3
"""Render exact STL previews using OpenSCAD; use xvfb-run on headless Linux."""
from __future__ import annotations
import argparse, shutil, subprocess, tempfile
from pathlib import Path
from PIL import Image, ImageChops
HERE=Path(__file__).resolve().parent
STEM='hex_bit_stand_continuous_web_217_v19'

def main() -> None:
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--openscad',default=shutil.which('openscad.com') or shutil.which('openscad'))
    args=parser.parse_args()
    if not args.openscad:
        parser.error('OpenSCAD is required.')
    prefix=['xvfb-run','-a'] if shutil.which('xvfb-run') else []
    mesh=(HERE/(STEM+'.stl')).as_posix()
    with tempfile.TemporaryDirectory(prefix='hex_v19_preview_') as directory:
        scene=Path(directory)/'scene.scad'
        scene.write_text(f'import("{mesh}");\n')
        for name,cam in [('perspective.png','0,0,7,50,0,28,450'),
                         ('top.png','0,0,7,0,0,0,450'),
                         ('underside.png','0,0,7,180,0,0,450')]:
            proc=subprocess.run(prefix+[args.openscad,'--render','--imgsize=1800,1500',
                                        '--projection=o','--viewall','--autocenter','--camera='+cam,
                                        '-o',str(HERE/name),str(scene)],
                                capture_output=True,text=True,timeout=60)
            (HERE/'evidence'/('render_'+Path(name).stem+'.log')).write_text(proc.stdout+proc.stderr)
            if proc.returncode:
                raise RuntimeError(f'Render failed: {name}\n{proc.stderr}')
            with Image.open(HERE/name) as original:
                image=original.convert("RGB")
                background=Image.new("RGB",image.size,image.getpixel((0,0)))
                box=ImageChops.difference(image,background).getbbox()
                if box:
                    pad=60
                    image.crop((max(0,box[0]-pad),max(0,box[1]-pad),
                                min(image.width,box[2]+pad),min(image.height,box[3]+pad))).save(HERE/name)
            print(name)
if __name__=='__main__':
    main()
