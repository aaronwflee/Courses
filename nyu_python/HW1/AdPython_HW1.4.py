#NUMBER GUESSER

raw_input('Think of an integer between 100 and 0, and I will try to guess it. \n Press ENTER to begin')

upper = 100
lower = 0
guess = (upper+lower)/2

while True:
    hyp = raw_input('Is it {}?  (Y/N)'.format(guess)).upper()
    if hyp == 'Y':
        print ('I knew it! Thanks for playing!')
        break
    elif hyp == 'N':
        hl = raw_input('Oops! Is it higher or lower?  (H/L)').upper()
        if hl == 'H':
            lower = guess
            guess = round((upper+guess)/2)
        elif hl == 'L':
            upper = guess
            guess = round((lower+guess)/2)
        else:
            print 'Input not recognized. Try again'
    else:
        print 'Input not recognized. Try again'
