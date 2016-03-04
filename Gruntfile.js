'use strict';

module.exports = function(grunt){
    //Configure de tasks
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        copy: {
            build: {
                cwd: "source",
                src: ['**'],
                dest: "build",
                expand: true
            }
        },
        clean: {
            build: {
                src: ["build"]
            },
            scripts: {
                src: [ 'build/**/*.js', /*'!build/<%= pkg.name %>.js',*/ '!build/<%= pkg.name %>_<%= pkg.version %>.min.js' ]
            },
            options: {
                force: true
            }
        },
        coffee: {
            build: {
                expand: true,
                cwd: 'src/',
                src: [ '**/*.coffee' ],
                dest: 'build',
                ext: '.js'
            }
        },
        uglify: {
            build: {
                options: {
                    mangle: false,
                    banner: '/*! <%= pkg.name %> <%= pkg.version %> <%= grunt.template.today("yyyy-mm-dd HH:MM:ss") %> */\n'
                },
                files: {
                        'build/<%= pkg.name %>_<%= pkg.version %>.min.js': ['build/<%= pkg.name %>.js']
                    }
            }
        }
    });
    
    //load the tasks
    grunt.loadNpmTasks("grunt-contrib-copy");
    grunt.loadNpmTasks('grunt-contrib-clean');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    
    //define the tasks
    grunt.registerTask(
        'scripts', 
        'Compiles the JavaScript files.',
        [ 'coffee', 'uglify', 'clean:scripts' ]
    );
 
    grunt.registerTask(
        'build',
        'Compiles all of the assets and copies the files to the build directory.',
        [ 'clean:build', 'copy', 'scripts']
    );
    
    grunt.registerTask(
        'default',
        'Watches the project for changes, automatically builds them and runs a server.',
        [ 'build']
    );
};