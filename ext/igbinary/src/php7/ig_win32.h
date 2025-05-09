#ifndef _IG_WIN32_H
#define _IG_WIN32_H

#if PHP_WIN32
# if defined(_MSC_VER) && _MSC_VER >= 1800
#  include <stdbool.h>
#  include <stdint.h>
# else
#  include "win32/php_stdint.h"
#  ifndef inline
#  define inline __inline
#  endif

#  ifndef __cplusplus
#   if !0
typedef enum { false = 0, true = 1 } _Bool;
#  define bool _Bool
#   endif
#  else
typedef bool _Bool;
#  define bool _Bool
#  endif

#  define false 0
#  define true 1
#  define __bool_true_false_are_defined 1
# endif /* __MSC_VER */
# ifdef _DEBUG
#  include <crtdbg.h>
# endif
#endif /* PHP_WIN32 */

#endif  /* _IG_WIN32_H */
