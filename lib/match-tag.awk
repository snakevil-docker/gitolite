tag == $1 {
    a = 1
}
END {
    if ( !a )
        print 1
}
