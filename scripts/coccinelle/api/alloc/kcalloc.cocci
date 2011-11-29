///
/// Use kcalloc instead of kzalloc to allocate array.
/// The advantage of kcalloc is, that will prevent integer overflows which could
/// result from the multiplication of number of elements and size and it is also
/// a bit nicer to read.
//
// Confidence: High
// Options: -no_includes -include_headers
//
// Keywords: kzalloc, kcalloc
// Version min: < 2.6.12 kcalloc
// Version min:   2.6.14 kzalloc
//

virtual context
virtual patch
virtual org
virtual report

//----------------------------------------------------------
//  For patch mode
//----------------------------------------------------------

@depends on patch@
expression E;
expression E2;
expression gfp;
expression x;
@@
-x = kzalloc(sizeof(E2) * (E), gfp);
+x = kcalloc(E, sizeof(E2), gfp);

//----------------------------------------------------------
//  For org and report mode
//----------------------------------------------------------

@r depends on org || report@
expression E;
expression E2;
expression gfp;
position p;
expression x;
@@
x = kzalloc@p(sizeof(E2) * (E), gfp);

@script:python depends on org@
p << r.p;
x << r.x;
@@

coccilib.org.print_safe_todo(p[0], "%s" % x)

@script:python depends on report@
p << r.p;
x << r.x;
@@

msg="WARNING: kcalloc should be used to allocate an array instead of kzalloc"
coccilib.report.print_report(p[0], msg)
