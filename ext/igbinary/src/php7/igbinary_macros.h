/*
  +----------------------------------------------------------------------+
  | See COPYING file for further copyright information                   |
  +----------------------------------------------------------------------+
  | See CREDITS for contributors                                         |
  +----------------------------------------------------------------------+
*/

// If a macro is needed by *only* igbinary, put it in this file.
#ifndef PHP_IGBINARY_MACROS_H
#define PHP_IGBINARY_MACROS_H

/** Backport macros from php 7.3 */
#ifndef GC_ADD_FLAGS
#define GC_ADD_FLAGS(obj, flag) GC_FLAGS(obj) |= flag
#endif

#endif
