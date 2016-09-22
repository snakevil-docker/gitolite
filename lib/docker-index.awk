BEGIN {
    a = -1
}
"gitolite" == $1 && 1 == index( $2, tag"-" ) {
    b = substr( $2, 2 + length( tag ) );
    if ( b > a )
        a = b
}
END {
    print 1 + a
}
