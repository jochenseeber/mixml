# Error checking

The following demonstrations test mixml's error checking. All examples on this page are designed to fail.

## Command without selector fails

Executing mixml to modify documents without a selector fails:

    # mixml rename --string 'tiger'

## Command with multiple values fails

Executing mixml to modify documents with multiple values fails:

    # mixml rename --xpath '//philosopher' --string 'tiger' --string 'scholar'

## Command with multiple value types fails

Executing mixml to modify documents with multiple value types fails:

    # mixml rename --xpath '//philosopher' --string 'tiger' --template 'scholar'

## Command without selector fails

Executing mixml to modify documents without a selector fails:

    # mixml rename --string 'tiger'
