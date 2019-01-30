BEGIN {
    print "// Code generated by parser/all_keywords.awk. DO NOT EDIT."
    print "// GENERATED FILE DO NOT EDIT"
    print ""
    print "package lex"
    print ""
    print "var Keywords = map[string]struct{"
    print "    Tok int"
    print "    Cat string"
    print "}{"

    # This variable will be associated with a pipe for intermediate output.
    sort = "env LC_ALL=C sort"
}

# Category codes are for pg_get_keywords, see
# src/backend/utils/adt/misc.c in pg's sources.
/^.*_keyword:/ {
  keyword = 1
  if ($1 == "col_name_keyword:") {
      category = "C"
  } else if ($1 == "unreserved_keyword:") {
      category = "U"
  } else if ($1 == "type_func_name_keyword:") {
      category = "T"
  } else if ($1 == "reserved_keyword:") {
      category ="R"
  } else {
      print "unknown keyword type:", $1 >>"/dev/stderr"
      exit 1
  }
  next
}

/^$/ {
  keyword = 0
}

{
  if (keyword && $NF != "") {
      printf("\"%s\": {%s, \"%s\"},\n", tolower($NF), $NF, category) | sort
  }
}

END {
    # Flush the intermediate output by closing the pipe.
    close(sort)
    print "}"
}