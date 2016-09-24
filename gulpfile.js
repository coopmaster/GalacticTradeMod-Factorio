var gulp = require('gulp');
var util = require( 'gulp-util' );

var name = "GalacticTrade";
var version = "0.6.5";
var modsFolder = "C:/Users/Giacomo/AppData/Roaming/Factorio/mods";

gulp.task('watch', ['build'], function() {
    gulp.watch(name+"/**/**/*", ['build']);
});

gulp.task('build', function() {
    gulp.src([name+"/**/**/*"]).pipe(gulp.dest(modsFolder+"/"+name+"_"+version));
});

gulp.task('default', ['watch']);