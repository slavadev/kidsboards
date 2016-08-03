'use strict';

var gulp = require('gulp');
var sass = require('gulp-sass');
var clean = require('gulp-clean');
var concat = require('gulp-concat');
var templateCache = require('gulp-angular-templatecache');
var htmlreplace = require('gulp-html-replace');
var runSequence = require('run-sequence');
var cssmin = require('gulp-cssmin');
var uglify = require('gulp-uglify');
var svgmin = require('gulp-svgmin');
var svgstore = require('gulp-svgstore');
var inject = require('gulp-inject');
var path = require('path');

var ver = '';

var paths = {
  js: {
    vendor: [
      'bower_components/angular/angular.js',
      'bower_components/angular-aria/angular-aria.js',
      'bower_components/angular-animate/angular-animate.js',
      'bower_components/angular-resource/angular-resource.js',
      'bower_components/angular-messages/angular-messages.js',
      'bower_components/angular-material/angular-material.js',
      'bower_components/angular-ui-router/release/angular-ui-router.min.js',
      'bower_components/angular-local-storage/dist/angular-local-storage.min.js',
      'bower_components/ng-file-upload-shim/ng-file-upload-shim.min.js',
      'bower_components/ng-file-upload/ng-file-upload.min.js',
      'app/js/**/*.js'
    ],
    app: [
      // core
      'app/core/js/module.js',
      'app/core/js/core.js',
      'app/core/js/config.js',
      'app/core/js/routing.js',
      // common
      'app/modules/common/common.js',
      'app/modules/common/js/directives/showInAdultModeDirective.js',
      'app/modules/common/js/directives/hideInAdultModeDirective.js',
      'app/modules/common/js/directives/adultModeDirective.js',
      'app/modules/common/js/directives/editableTextDirective.js',
      'app/modules/common/js/directives/editableImageDirective.js',
      'app/modules/common/js/directives/imageDirective.js',
      'app/modules/common/js/directives/numPadDirective.js',
      'app/modules/common/js/directives/logoutDirective.js',
      'app/modules/common/js/directives/svgInlineDirective.js',
      'app/modules/common/js/directives/leftPanelDirective.js',
      'app/modules/common/js/directives/deleteButtonDirective.js',
      'app/modules/common/js/services/photoUploadService.js',
      'app/modules/common/js/services/loginService.js',
      'app/modules/common/js/services/resourceWrapService.js',
      'app/modules/common/js/services/errorHandlerService.js',
      'app/modules/common/js/services/apiLinkService.js',
      // family
      'app/modules/family/family.js',
      'app/modules/family/js/repositories/familyRepository.js',
      'app/modules/family/js/familyNewController.js',
      'app/modules/family/js/familyController.js',
      // adults
      'app/modules/adults/adults.js',
      'app/modules/adults/js/repositories/adultRepository.js',
      'app/modules/adults/js/adultNewController.js',
      'app/modules/adults/js/adultController.js',
      // children
      'app/modules/children/children.js',
      'app/modules/children/js/repositories/childRepository.js',
      'app/modules/children/js/childNewController.js',
      'app/modules/children/js/childController.js',
      // goals
      'app/modules/goals/goals.js',
      'app/modules/goals/js/repositories/goalRepository.js',
      'app/modules/goals/js/goalNewController.js',
      'app/modules/goals/js/goalController.js',
      // index
      'app/modules/index/index.js',
      'app/modules/index/js/indexController.js',
      'app/modules/index/js/requestRecoveryController.js',
      'app/modules/index/js/recoveryController.js',
      'app/modules/index/js/confirmController.js'
    ]
  },
  css: {
    vendor: [
      'bower_components/angular-material/angular-material.css'
    ],
    app: [
      'css/main.css',
      'css/index.css',
      'css/family.css',
      'css/family_new.css',
      'css/child.css',
      'css/child_new.css',
      'css/adult.css',
      'css/adult_new.css',
      'css/goal.css',
      'css/goal_new.css',
      'css/editable-text.css',
      'css/editable-image.css',
      'css/num-pad.css'
    ]
  },
  images: [ 'images/**/*' ],
  json:   [ 'json/**/*' ],
  fonts:  [ 'css/fonts/**/*' ]
};

gulp.task('clean', function () {
  return gulp.src('dist/*', {read: false})
    .pipe(clean());
});

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

gulp.task('jsbuild:vendor', function(){
  return gulp.src(paths.js.vendor)
    .pipe(uglify())
    .pipe(concat('vendor' + ver + '.min.js'))
    .pipe(gulp.dest('dist/js'));
});

gulp.task('jsbuild:app', function(){
  return gulp.src(paths.js.app)
    .pipe(uglify())
    .pipe(concat('app' + ver + '.min.js'))
    .pipe(gulp.dest('dist/js'));
});

gulp.task('jsbuild', ['jsbuild:vendor', 'jsbuild:app']);

gulp.task('cssbuild:vendor', function(){
  return gulp.src(paths.css.vendor)
    .pipe(cssmin())
    .pipe(concat('vendor' + ver + '.min.css'))
    .pipe(gulp.dest('dist/css'));
});

gulp.task('cssbuild:app', function(){
  return gulp.src(paths.css.app)
    .pipe(cssmin())
    .pipe(concat('app' + ver + '.min.css'))
    .pipe(gulp.dest('dist/css'));
});

gulp.task('cssbuild', ['cssbuild:vendor', 'cssbuild:app']);


gulp.task('templates', function () {
  return gulp.src('app/**/*.html')
    .pipe(templateCache('templates' + ver + '.js', {standalone: true, root: '/app/'}))
    .pipe(gulp.dest('dist/templates'));
});

gulp.task('index-dist', function() {
  gulp.src('index.html')
    .pipe(htmlreplace({
      'css': ['css/vendor' + ver + '.min.css', 'css/app' + ver + '.min.css'],
      'js': ['js/vendor' + ver + '.min.js', 'templates/templates' + ver + '.js', 'js/app' + ver + '.min.js']
    }))
    .pipe(gulp.dest('dist/'));
});

gulp.task('images', function() {
  return gulp.src(paths.images)
    .pipe(gulp.dest('dist/images'));
});

gulp.task('json', function() {
  return gulp.src(paths.json)
    .pipe(gulp.dest('dist/json'));
});

gulp.task('fonts', function() {
  return gulp.src(paths.fonts)
    .pipe(gulp.dest('dist/css/fonts'));
});

gulp.task('watch', ['sass:watch']);

gulp.task('build-dev',['svgstore', 'sass']);

gulp.task('build', function(callback){
  ver = makeVer();

  runSequence(
    ['svgstore', 'sass'],
    ['images', 'templates', 'jsbuild', 'cssbuild', 'json', 'fonts'],
    'index-dist',
    callback);
});

function makeVer()
{
  var text = "-";
  var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

  for( var i=0; i < 10; i++ )
    text += possible.charAt(Math.floor(Math.random() * possible.length));

  return text;
}