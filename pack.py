"""Build Debian archives with explicit parent directories and root ownership."""
import sys, pathlib, tempfile, tarfile, subprocess
root=pathlib.Path(sys.argv[1]).resolve()
for pkg,name in [('ui','CameraUI-0.2'),('jetsam','camera-jetsam-1.2')]:
    with tempfile.TemporaryDirectory() as tmp:
        t=pathlib.Path(tmp)
        (t/'debian-binary').write_bytes(b'2.0\n')
        for part in ['control','data']:
            base=root/pkg
            if part=='control': base=base/'DEBIAN'
            with tarfile.open(t/(part+'.tar.gz'),'w:gz',format=tarfile.USTAR_FORMAT) as a:
                for p in sorted(base.rglob('*')):
                    rel=p.relative_to(base)
                    if rel.parts[0]=='DEBIAN': continue
                    i=a.gettarinfo(str(p),'./'+str(rel)); i.uid=i.gid=0;i.uname=i.gname='root'
                    if p.is_file():
                        with p.open('rb') as f:a.addfile(i,f)
                    else:a.addfile(i)
        subprocess.run(['ar','rc','out.deb','debian-binary','control.tar.gz','data.tar.gz'],cwd=t,check=True)
        (pathlib.Path('packages')/(name+'.deb')).write_bytes((t/'out.deb').read_bytes())
