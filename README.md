# EENG 515: Improving FLAC

Project for EENG 515: Mathematical Methods for Signals and Systems focused on analyzing and
improving the free lossless audio codec.

No project focus yet, but current options are:

- Something like non-local means for prediction
    - Pull in samples outside of normal previous $n$
- Use ILRS instead $L_2$ norm for prediction
- Utilize spectrum for prediction selection
- Target a specific type or class of signal to try to acheive better compression than normal FLAC
    - Could involve altering the normal fixed coefficient matrix that FLAC uses
