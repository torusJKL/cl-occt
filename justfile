root-dir := justfile_directory()
occt-version := "8.0.0"
occt-url := "https://github.com/Open-Cascade-SAS/OCCT/archive/refs/tags/V" + replace(occt-version, ".", "_") + ".tar.gz"
occt-tarball := root-dir + "/.local/occt.tar.gz"
occt-src := root-dir + "/.local/occt-src"
occt-build := root-dir + "/.local/occt-build"
occt-install := root-dir + "/.local"
sbcl := "sbcl"

default:
    @echo "clocct — Common Lisp + OCCT Parametric CAD"
    @echo ""
    @echo "Usage: just <recipe>"
    @echo ""
    @echo "Recipes:"
    @echo "  setup       Download & build OCCT {{occt-version}} (one-time ~15 min)"
    @echo "  wrap        Compile C wrapper → lib/libocctwrap.so"
    @echo "  start       Launch SBCL REPL with cl-occt loaded (via Quicklisp)"
    @echo "  repl        Launch SBCL REPL with cl-occt loaded (standalone)"
    @echo "  test-core   Run ~200 core tests (geometry, I/O, DAG) — no X display needed"
    @echo "  test-viewer Run ~80 viewer tests (rendering, AIS, camera) — needs xvfb-run"
    @echo "  test-all    Run all 288 tests under xvfb-run"
    @echo "  clean       Remove build artifacts"

setup:
    # Download and build OCCT 8.0.0
    mkdir -p {{root-dir}}/.local
    curl -Lo {{occt-tarball}} {{occt-url}}
    mkdir -p {{occt-src}}
    tar xzf {{occt-tarball}} -C {{occt-src}} --strip-components=1
    mkdir -p {{occt-build}}
    cd {{occt-build}} && cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX={{occt-install}} \
        -DBUILD_LIBRARY_TYPE=Shared \
        -DBUILD_MODULE_ApplicationFramework=ON \
        -DBUILD_MODULE_DataExchange=ON \
        -DBUILD_MODULE_Draw=OFF \
        -DBUILD_MODULE_FoundationClass=ON \
        -DBUILD_MODULE_ModelingAlgorithms=ON \
        -DBUILD_MODULE_ModelingData=ON \
        -DBUILD_MODULE_Visualization=ON \
        {{occt-src}}
    cmake --build {{occt-build}} -- -j$(nproc)
    cmake --install {{occt-build}}

wrap:
    mkdir -p lib
    g++ -shared -fPIC -std=c++17 -o lib/libocctwrap.so \
        wrap/occt_wrap.cpp \
        -I{{occt-install}}/include/opencascade \
        -L{{occt-install}}/lib \
        -lTKernel -lTKMath -lTKG2d -lTKG3d -lTKBRep -lTKPrim -lTKBool \
        -lTKDESTEP -lTKXSBase -lTKDESTL -lTKMesh -lTKXCAF -lTKCAF \
        -lTKV3d -lTKOpenGl -lTKService \
        -Wl,-rpath,{{occt-install}}/lib

start:
    LD_LIBRARY_PATH={{root-dir}}/lib:{{occt-install}}/lib \
    {{sbcl}} --load ~/quicklisp/setup.lisp \
            --eval "(push \"{{root-dir}}/\" asdf:*central-registry*)" \
            --eval "(asdf:load-system :cl-occt)" \
            --eval "(in-package :cl-occt)"

repl:
    LD_LIBRARY_PATH={{root-dir}}/lib:{{occt-install}}/lib \
    {{sbcl}} --eval "(require :asdf)" \
            --eval "(push \"{{root-dir}}/\" asdf:*central-registry*)" \
            --eval "(asdf:load-system :cl-occt)" \
            --eval "(in-package :cl-occt)"

clean:
    rm -rf {{occt-build}} {{occt-src}} {{occt-tarball}}

test-core:
    # Run core tests (geometry, I/O, DAG, colors, text shapes) — no X display needed
    LD_LIBRARY_PATH={{root-dir}}/lib:{{occt-install}}/lib \
    {{sbcl}} --noinform \
        --eval "(require :asdf)" \
        --eval "(push \"{{root-dir}}/\" asdf:*central-registry*)" \
        --eval "(asdf:load-system :cl-occt/tests)" \
        --eval "(cl-occt::run-core-tests)" \
        --eval "(sb-ext:quit)"

test-viewer:
    # Run viewer tests (rendering, AIS, camera, grid, lighting) — needs X display
    xvfb-run -a sh -c 'cd {{root-dir}} && LD_LIBRARY_PATH={{root-dir}}/lib:{{occt-install}}/lib {{sbcl}} --noinform --eval "(require :asdf)" --eval "(push \"{{root-dir}}/\" asdf:*central-registry*)" --eval "(asdf:load-system :cl-occt/tests)" --eval "(cl-occt::run-viewer-tests)" --eval "(sb-ext:quit)"'

test-all:
    # Run all tests under xvfb-run
    xvfb-run -a sh -c 'cd {{root-dir}} && LD_LIBRARY_PATH={{root-dir}}/lib:{{occt-install}}/lib {{sbcl}} --noinform --eval "(require :asdf)" --eval "(push \"{{root-dir}}/\" asdf:*central-registry*)" --eval "(asdf:load-system :cl-occt/tests)" --eval "(cl-occt::run-tests)" --eval "(sb-ext:quit)"'
