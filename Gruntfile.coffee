'use strict'

module.exports = (grunt) ->

  require 'coffee-errors'

  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-csslint'
  grunt.loadNpmTasks 'grunt-jsonlint'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-simple-mocha'
  grunt.loadNpmTasks 'grunt-notify'

  grunt.registerTask 'test', [
    'csslint'
    'jsonlint'
    'coffeelint'
    'simplemocha'
  ]

  grunt.registerTask 'default', [ 'test', 'watch' ]

  grunt.initConfig

    csslint:
      strict:
        src: [
          '**/*.css'
          '!node_modules/**'
        ]

    jsonlint:
      config:
        src: [
          '**/*.json'
          '!node_modules/**'
        ]

    coffeelint:
      options:
        max_line_length:
          value: 119
        indentation:
          value: 2
        newlines_after_classes:
          level: 'error'
        no_empty_param_list:
          level: 'error'
        no_unnecessary_fat_arrows:
          level: 'ignore'
      dist:
        files:
          src: [
            '**/*.coffee'
            '!node_modules/**'
          ]

    simplemocha:
      options:
        ui: 'bdd'
        reporter: 'spec'
        compilers: 'coffee:coffee-script'
        ignoreLeaks: no
      dist:
        src: [ 'tests/test_*.coffee' ]

    watch:
      options:
        interrupt: yes
      dist:
        files: [
          '**/*.{coffee,js,jade,css}'
          '!node_modules/**'
          '!.git/**'
        ]
        tasks: [ 'test' ]
