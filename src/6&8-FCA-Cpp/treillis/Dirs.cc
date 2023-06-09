#include "Dirs.hh"


int CreateSubPath(const char *path)
{
  mode_t mode = S_IRWXU | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH;
  int ret;

  ret = mkpath(path, mode);
  return (ret);
}



/* ** Code get on internet ** */

/*
#Version:        $Revision: 1.13 $
#Last changed:   $Date: 2012/07/15 00:40:37 $
#Purpose:        Create all directories in path
#Author:         J Leffler
#Copyright:      (C) JLSS 1990-91,1997-98,2001,2005,2008,2012

(You are hereby given permission to use this code for any purpose with attribution.)
*/

// Modified by Fabrice for adaptation and portability (2019)

static int do_mkdir(const char *path, mode_t mode)
{
    struct stat     st;
    int             status = 0;

    if (stat(path, &st) != 0)
    {
        /* Directory does not exist. EEXIST for race condition */
        if (mkdir(path, mode) != 0 && errno != EEXIST)
            status = -1;
    }
    else if (!S_ISDIR(st.st_mode))
    {
        errno = ENOTDIR;
        status = -1;
    }

    return(status);
}

/**
** mkpath - ensure all directories in path exist
** Algorithm takes the pessimistic view and works top-down to ensure
** each directory in path exists, rather than optimistically creating
** the last element and working backwards.
*/
int mkpath(const char *path, mode_t mode)
{
    char           *pp;
    char           *sp;
    int             status;
    char           *copypath = my_strdup(path);
    status = 0;
    pp = copypath;
    while (status == 0 && (sp = strchr(pp, '/')) != 0)
    {
        if (sp != pp)
        {
            /* Neither root nor double slash in path */
            *sp = '\0';
            status = do_mkdir(copypath, mode);
            *sp = '/';
        }
        pp = sp + 1;
    }
    if (status == 0)
        status = do_mkdir(path, mode);
    free(copypath);
    return (status);
}
