import { type Build } from 'cmake-ts-gen';

const build: Build = {
    common: {
        project: 'libcsv',
        archs: ['x64'],
        variables: [],
        defines: [],
        options: [],
        copy: {},
        subdirectories: [],
        libraries: {
            libcsv: {
                sources: ['libcsv/libcsv.c']
            }
        },
        buildDir: 'build',
        buildOutDir: 'libs',
        buildFlags: []
    },
    platforms: {
        win32: {
            windows: {},
            android: {
                archs: ['x86', 'x86_64', 'armeabi-v7a', 'arm64-v8a'],
            }
        },
        linux: {
            linux: {}
        },
        darwin: {
            macos: {}
        }
    }
}

export default build;