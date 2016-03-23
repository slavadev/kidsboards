'use strict';

var gulp = require('gulp');
var sass = require('gulp-sass');
var svgmin = require('gulp-svgmin');
var svgstore = require('gulp-svgstore');
var inject = require('gulp-inject');
var path = require('path');

gulp.task('sass', function () {
  return gulp.src('./scss/**/*.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest('./css'));
});

gulp.task('sass:watch', function () {
  gulp.watch('./scss/**/*.scss', ['sass']);
});

gulp.task('svgstore', function () {
  var svgs = gulp
    .src('images/svg/*.svg')
    .pipe(svgmin(function (file) {
      var prefix = path.basename(file.relative, path.extname(file.relative));
      return {
        plugins: [{
          cleanupIDs: {
            prefix: prefix + '-',
            minify: true
          }
        }]
      }
    }))
    .pipe(svgstore({ inlineSvg: true }))

  function fileContents (filePath, file) {
    return file.contents.toString();
  }

  return gulp
    .src('app/core/templates/svg-inject.js')
    .pipe(inject(svgs, { transform: fileContents }))
    .pipe(gulp.dest('app/js'));
});

gulp.task('watch', ['sass:watch']);