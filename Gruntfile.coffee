"use strict"
module.exports = (grunt) ->
  
  # Project configuration.
  grunt.initConfig
    concat:
      options:
        separator: ";"
      app:
        src: ["assets/js/app/*.js"]
        dest: "public/javascripts/app.js"

    uglify:
      apps:
        src: "public/javascripts/app.js"
        dest: "public/javascripts/app.min.js"

    cssmin:
      pc:
        src: "public/stylesheets/style.css"
        dest: "public/stylesheets/style.min.css"

    compass:
      dist:
        options:
          sassDir: "assets/scss"
          cssDir: "public/stylesheets"
          config: "assets_config.rb"

    coffee:
      app:
        expand: true
        flatten: true
        cwd: "assets/coffee"
        src: ["app/**/*.coffee"]
        dest: "assets/js/app"
        ext: ".js"

    watch:
      options:
        spawn: false

      compass:
        files: "assets/scss/**/*.scss"
        tasks: [
          "compass"
          "cssmin"
        ]

      js:
        files: [
          "assets/js/**/*.js"
          "assets/coffee/**/*.coffee"
        ]
        tasks: [
          "coffee"
          "concat"
          "uglify"
        ]  

  # These plugins provide necessary tasks.
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-cssmin"
  grunt.loadNpmTasks "grunt-contrib-compass"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-contrib-watch"
  
  #grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.registerTask "default", [
    "compass"
    "cssmin"
    "coffee"
    "concat"
    "uglify"
  ]
  return