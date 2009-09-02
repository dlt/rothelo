#include<ruby.h>
#include<stdio.h>
#include<stdlib.h>

static VALUE rb_cAlphabeta;

static VALUE rb_mRothelo;

static VALUE rb_mHeuristics;

static double total_score;

static int current_player;

static VALUE each_field(VALUE board) {
  return rb_funcall(board, rb_intern("each_field"), 0, 0);
}  

double score_points(int x, int y, int player) {
  if (player == 0) return 0.0;

  extern current_player;
  int other = 3 - player;

  double score_unit = 0.5;
  double total, other_total = 0.0;

  if (player == current_player) {
    total += 10 * score_unit;
    if (x == 0 || y == 0) total += score_unit;
    if (x == 0 && y == 0) total += 3 * score_unit;
    if (x == 6 || y == 6) total -= 4 * score_unit;
    if (x == 1 || y == 1) total -= 4 * score_unit;
  } else {
    other_total += 10 * score_unit;
    if (x == 0 || y == 0) other_total += score_unit;
    if (x == 0 && y == 0) other_total += 3 * score_unit;
    if (x == 6 || y == 6) other_total -= 4 * score_unit;
    if (x == 1 || y == 1) other_total -= 4 * score_unit;
  }
  
  return total - other_total;
}

static VALUE sum_points(VALUE block_params) {
  extern current_player;
  int other = 3 - current_player;
  int x, y, player;
  VALUE *array_ptr = RARRAY(block_params)->ptr;

  x = FIX2INT(array_ptr[0]);
  y = FIX2INT(array_ptr[1]);
  player = FIX2INT(array_ptr[2]);

  if (player != 0) total_score += score_points(x, y, player);

  return Qnil;
}
static VALUE evaluate_game_opt(VALUE self, VALUE game) {
  current_player = NUM2INT(rb_funcall(game, rb_intern("current_player"), 0));
  VALUE board = rb_funcall(game, rb_intern("board"), 0);

  rb_iterate(each_field, board, sum_points, self);
  return INT2FIX(total_score);
}




void Init_alphabeta() {
  rb_mRothelo = rb_define_module("Rothelo");
  rb_mHeuristics = rb_define_module_under(rb_mRothelo, "Heuristics");
  rb_cAlphabeta = rb_define_class_under(rb_mHeuristics, "AlphaBetaPruning", rb_cObject);

  rb_define_method(rb_cAlphabeta, "evaluate_game_opt", evaluate_game_opt, 1);
  rb_define_method(rb_cAlphabeta, "each_field", each_field, 0);
  rb_define_method(rb_cAlphabeta, "sum_points", sum_points, 3);

}
