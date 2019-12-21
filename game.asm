;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;	☯ AUTHORS
;	▷ Mehedi Hasan
;	▷ Monirul Haque
;	▷ Shihab Uddin Sikder
;	▷ Shafiul Muslebeen
;	© 2019 CATCH THE LETTER
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

.model  small
;.stack 100H
 
.data
    row db 80 DUP (1)            		; contains in which row the character is at of the index column
    column db 80 DUP (32)        		; contains the character which is at row = column[index], column = index position 
    generatedRandom dw ?
    temp    dw 0        
    scoreLSB  db 30h                	; LSB
    scoreMSB  db 30h                	; MSB
    lives   db 56                   	; Total lives
    temp2   db 0                    	; Char temp
    startPosition   dw 0            	; Start position temp
    keyInput    dw 0                	; Keyboard input temp
    delay   db 10
    tempTime   db 0
    mulTime db 0
	graRow db -1
	graCol db 0
	
	gameTitle db "CATCH ME IF YOU CAN!"
	difficulty db "Select Difficulty:"
	noob db "Noob"
	regular db "Regular"
	hardended db "Hardended"
	veteran db "Veteran"
	play db "PLAY"
	about db "ABOUT"
	help db "HELP"
	quit db "QUIT"
	helpText db "Type to catch the letters"
	helpText1 db "before they touch the ground."
	about0 db "Developed by:"
	about1 db "Mehedi Hasan"
	about2 db "Monirul Haque"
	about3 db "Shihab Uddin Sikder"
	about4 db "Shafiul Muslebeen"
	about5 db "CSE"
	about6 db "BRACU"

    
    ;Message
    showScore db "Score:"
    remainingLives db "lives: "
    gameOverShow db "GAMEOVER!!!"
    exitMessage db "....Press any key to continue"
    spa db "     "
 
.code   
    ;mov dx, offset msg					; print welcome message:
    ;mov ah, 9 
    ;int 21h
    ;mov ah, 00h						;wait for any key:
    ;int 16h  
main:
    mov ax, @data
    mov ds, ax
    CALL randomInitializer
    MOV AH, 00H ; Set video mode
    MOV AL, 13H ; Mode 13h
    INT 10H             				; Setting display mode also clears the screen
										; We are invoking BIOS video screen rgoine using INT 10h interruption function
										; Hide blinking text editing cursor:
    ;mov     ah, 1       				; Set text-mode cursor shape
    ;mov     ch, 32      				; Row no = 32, column no= 0
    ;int     10h                     

menu:
    MOV AX, @DATA 						;important
    MOV ES, AX
	call screenClear
	mov		BP,offset gameTitle			;print string gameTitle
	MOV 	AH,13h
	MOV		BH,0h
	MOV		BL,0Eh
	MOV		AL,00h						;Write mode
	MOV 	CX,20						;Number of char in Str.
	MOV 	DL,10						; Column
	MOV		DH,5						; Row
	INT		10h
	mov		BP,offset play				;print string play
	MOV 	AH,13h
	MOV		BH,0h
	MOV		BL,0Dh
	MOV		AL,00h						;Write mode
	MOV 	CX,4						;Number of char in Str.
	MOV 	DL,17						; Column
	MOV		DH,10						; Row
	INT		10h
	mov		BP,offset about				;print string about
	MOV 	AH,13h
	MOV		BH,0h
	MOV		BL,0Dh
	MOV		AL,00h						;Write mode
	MOV 	CX,5						;Number of char in Str.
	MOV 	DL,17						; Column
	MOV		DH,12						; Row
	INT		10h	
	mov		BP,offset help				;print string help
	MOV 	AH,13h
	MOV		BH,0h
	MOV		BL,0Dh
	MOV		AL,00h						;Write mode
	MOV 	CX,4						;Number of char in Str.
	MOV 	DL,17						;Column
	MOV		DH,14						;Row
	INT		10h
	mov		BP,offset quit				;print string quit
	MOV 	AH,13h
	MOV		BH,0h
	MOV		BL,0Dh
	MOV		AL,00h						;Write mode
	MOV 	CX,4						;Number of char in Str.
	MOV 	DL,17						;Column
	MOV		DH,16						;Row
	INT		10h
	
@play1:
	MOV		AH,0						;get char to AL
	INT		16h	
	CMP 	AL,49						;check 3 for Hardended
	JNE 	@about1
	JMP 	diffMenu1

@about1:CMP 	AL,50					;check 3 for Veteran
	JNE 	@help1
	JMP 	diffMenu
	
@help1:CMP 	AL,51						;check 3 for Veteran
	JNE 	@escape1
	JMP 	diffMenu2
	
@escape1:CMP	AL,27					;check ESC
	JNE		@play1
	JMP 	haltProgram
	
menu1:
	jmp menu
	
diffMenu:
	call screenClear
	mov		BP,offset about0			;print string
	MOV 	AH,13h
	MOV		BH,0h
	MOV		BL,0Fh
	MOV		AL,00h						;Write mode
	MOV 	CX,13						;Number of char in Str.
	MOV 	DL,12						; Column
	MOV		DH,6						; Row
	INT		10h
	
	mov		BP,offset about1			;print string
	MOV 	AH,13h
	MOV		BH,0h
	MOV		BL,0Fh
	MOV		AL,00h						;Write mode
	MOV 	CX,12						;Number of char in Str.
	MOV 	DL,13						;Column
	MOV		DH,8						;Row
	INT		10h
	
	mov		BP,offset about2			;print string
	MOV 	AH,13h
	MOV		BH,0h
	MOV		BL,0Fh
	MOV		AL,00h						;Write mode
	MOV 	CX,13						;Number of char in Str.
	MOV 	DL,13						;Column
	MOV		DH,10						;Row
	INT		10h
	
	mov		BP,offset about3			;print string
	MOV 	AH,13h
	MOV		BH,0h
	MOV		BL,0Fh
	MOV		AL,00h						;Write mode
	MOV 	CX,19						;Number of char in Str.
	MOV 	DL,10						;Column
	MOV		DH,12						;Row
	INT		10h
	
	mov		BP,offset about4			;print string
	MOV 	AH,13h
	MOV		BH,0h
	MOV		BL,0Fh
	MOV		AL,00h						;Write mode
	MOV 	CX,17						;Number of char in Str.
	MOV 	DL,11						;Column
	MOV		DH,14						;Row
	INT		10h
	mov		BP,offset about5			;print string
	MOV 	AH,13h
	MOV		BH,0h
	MOV		BL,0Fh
	MOV		AL,00h						;Write mode
	MOV 	CX,3						;Number of char in Str.
	MOV 	DL,17						;Column
	MOV		DH,16						;Row
	INT		10h
	
	mov		BP,offset about6			;print string
	MOV 	AH,13h
	MOV		BH,0h
	MOV		BL,0Fh
	MOV		AL,00h						;Write mode
	MOV 	CX,5						;Number of char in Str.
	MOV 	DL,16						;Column
	MOV		DH,18						;Row
	INT		10h
@escape2:MOV		AH,0				;get char to AL
	INT		16h	
	CMP 	AL,27						;check 3 for Hardended
	JNE 	@escape2
	JMP 	menu
diffMenu2:
	call screenClear
	mov		BP,offset helpText			;print string
	MOV 	AH,13h
	MOV		BH,0h
	MOV		BL,0Fh
	MOV		AL,00h						;Write mode
	MOV 	CX,25						;Number of char in Str.
	MOV 	DL,7						;Column
	MOV		DH,10						;Row
	INT		10h
	mov		BP,offset helpText1			;print string
	MOV 	AH,13h
	MOV		BH,0h
	MOV		BL,0Fh
	MOV		AL,00h						;Write mode
	MOV 	CX,29						;Number of char in Str.
	MOV 	DL,5						;Column
	MOV		DH,12						;Row
	INT		10h
@escape3:
	MOV		AH,0						;get char to AL
	INT		16h	
	CMP 	AL,27						;check 3 for Hardended
	JNE 	@escape3
	JMP 	menu
diffMenu1:
	call screenClear
	MOV AX, @DATA ;important
    MOV ES, AX
	mov		BP,offset difficulty		;print string difficulty
	MOV 	AH,13h
	MOV		BH,0h
	MOV		BL,0Fh
	MOV		AL,00h
	MOV 	CX,18
	MOV 	DL,11
	MOV		DH,6	
	INT		10h
	mov		BP,offset noob				;print string noob
	MOV 	AH,13h
	MOV		BH,0h
	MOV		BL,0Ah
	MOV		AL,0
	MOV 	CX,4
	MOV 	DL,16
	MOV		DH,8
	INT		10h
	mov		BP,offset regular			;print string regular
	MOV 	AH,13h
	MOV		BH,0h
	MOV		BL,02h
	MOV		AL,0
	MOV 	CX,7
	MOV 	DL,16
	MOV		DH,10
	INT		10h	
	mov		BP,offset hardended			;print string hardended
	MOV 	AH,13h
	MOV		BH,0h
	MOV		BL,0Eh
	MOV		AL,0
	MOV 	CX,9
	MOV 	DL,16
	MOV		DH,12
	INT		10h
	mov		BP,offset veteran			;print string veteran
	MOV 	AH,13h
	MOV		BH,0h
	MOV		BL,04h
	MOV		AL,0
	MOV 	CX,7
	MOV 	DL,16
	MOV		DH,14
	INT		10h
	jmp 	@diffiNoob

menu2:
	jmp menu1
	
@diffiNoob:
	MOV		AH,0						;get char to AL
	INT		16h							; choose difficulty
	CMP		AL,49						;check 1 for noob
	JNE		@diffiRegular
	MOV 	delay,20
	JMP		start
	
@diffiRegular:
	CMP 	AL,50						;check 2 for Regular
	JNE 	@diffiHardended
	MOV 	delay,16
	JMP 	start
	
@diffiHardended:
	CMP 	AL,51						;check 3 for Hardended
	JNE 	@diffiVeteran
	MOV 	delay,10
	JMP 	start

@diffiVeteran:
	CMP 	AL,52						;check 3 for Veteran
	JNE 	@escape
	MOV 	delay,6
	JMP 	start
	
@escape:
	CMP	AL,27							;check ESC
	JNE		@diffiNoob
	JMP 	menu


start:             
    MOV AX, @DATA 						; important
    MOV ES, AX
    CALL 	screenClear
    MOV BP, OFFSET showScore 			; ES: BP POINTS TO THE TEXT
    MOV AH, 13H 						; WRITE THE STRING
    MOV AL, 01H							; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
    XOR BH,BH 							; VIDEO PAGE = 0
    MOV BL, 2 							; GREEN
    MOV CX, 6 							; LENGTH OF THE STRING
    MOV DH, 0 							; ROW TO PLACE STRING
    MOV DL, 2 							; COLUMN TO PLACE STRING
    INT 10H
	
    MOV AX, @DATA 						; important
    MOV ES, AX
    MOV BP, OFFSET remainingLives 		; ES: BP POINTS TO THE TEXT
    MOV AH, 13H 						; WRITE THE STRING
    MOV AL, 01H							; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
    XOR BH,BH 							; VIDEO PAGE = 0
    MOV BL, 0Ch 						; GREEN
    MOV CX, 7 							; LENGTH OF THE STRING
    MOV DH, 0 							; ROW TO PLACE STRING
    MOV DL, 28 							; COLUMN TO PLACE STRING
    INT 10H
	
    MOV AX, @DATA 						;important
	MOV DS, AX

gameStart:                     			;Loop the game
    CALL    getColumn
    mov     bx,0
    CALL    checkRowPrint
    Call    keyMatch
    CALL    setDelay        
    JMP     gameStart          			;looping ;;keeps the game running 


getColumn:                       
    CALL    randomColumn
    CMP     row[bx],1       			;row
    ;JNE     getColumn
    INC     row[bx]          			;just for safety as we decrease in setCursor
    mov     startPosition,bx
    CALL    randomType
    mov     bx,startPosition
    mov     column[bx],dl
	RET
incCol: INC bx
checkRowPrint:                  		;checking each line to move forward
    CMP     bx,40
    JE      returnCRP
    CMP     row[bx],1
    JE      incCol
    mov     temp,bx
    CALL    printAndVanish
    mov     bx,temp
    JMP     incCol
returnCRP: RET

menu3:
	jmp menu2

randomInitializer:              		;change generatedRandom each each frame
    mov ah,0                    		;Get system delay      
    INT 1ah                     		;there are approximately 18.20648 clock ticks per second,and 1800B0h per 24 hours.      
    mov generatedRandom,DX
										;CX:DX now hold number of clock ticks since midnight
										;CH = hour. CL = minute. DH = second. DL = 1/100 seconds.
										;Move dx Register to generatedRandom
    RET 
randomColumn:                       	;random algorithm by using generatedRandom from RandomInitializer
    mov ax, generatedRandom
    ADD generatedRandom,23
    xor dx, dx
    mov cx, 40
    DIV cx                      		;dx contains the remainder of the division from 0 to 40
    mov BX,DX
    ;ADD BX, 15                  		;Shift Screen Position
    RET                         		;result random number at AL 
randomSelection:                      	;Random type to display
    mov     AX, generatedRandom         ;Determining randomly to select character, we mod by 3 here
    xor     DX, DX               		;0 = Number, 1 = Upper Case letter, 2 = Lower Case letter
    mov     CX, 3
    DIV     CX      
    RET         
randomType:                      		;Select type from randomSelection function
    CALL    randomSelection           
    CMP     DL,0
    JE      number
    CMP     DL,1
    JE      upperCase
    CMP     DL,2
    JE      lowerCase  
number:                       			;Random number
    mov     AX, generatedRandom 
    ;ADD     generatedRandom,1
    xor     DX, DX      
    mov     CX, 10
    DIV     CX 
    ADD     DL, 48              		;DL contains random number 0 - 9
    ;mov     AL,DL
    RET 
upperCase:                     			;Random Capital Characters
    mov     AX, generatedRandom 
    ;ADD     generatedRandom,1
    mov     DX, 0       
    mov     CX, 26
    DIV     CX                  		; DX contains the remainder of the division from 0 to 93
    ADD     DL, 65              		; DL contain rand char A - Z
    ;mov     AL,DL
    RET 
lowerCase:                     			;Random Lower Characters
    mov     AX, generatedRandom 
    ;ADD     generatedRandom,1
    xor     DX, DX       
    mov     CX, 26 
    DIV     CX                  		; DX contains the remainder of the division from 0 to 93
    ADD     DL, 97              		; DL contain rand char a - z
    ;mov     AL,DL   
    RET

setDelay:                              
	mov    ah, 2ch                 		; Get delay from system
	INT        21h                                 
	mov        tempTime,DL              ; CH = hour. CL = minute. DH = second. DL = 1/100 seconds.
	mov        AH,delay
	mov    mulTime,ah            		; delay a delay estimate 5* delay milli second
	CALL    printScore
	CALL    printLives


delay2:                             	; Modified delay speed for level
	CALL    keyMatch
	mov    AH,2Ch
	INT        21h
	CMP        DL,tempTime
	JE     delay2
	DEC        mulTime
	mov        tempTime,DL
	CMP        mulTime,0
	JNE        delay2
	RET


printChar:                           	; Print Characters one by one
	mov     ah, 9h                  	; write character from AL at cursor position.
	mov     bh, 0h                  	; Page no = 0
	mov     cx, 1                   	;no. of times to write character
	INT     10h
	RET
	
printAndVanish:
	CALL    setCursor  
	mov     bx,temp
	mov     al,column[bx]
	mov     bl, 0Eh                 	; Color of letters and numbers (Yellow)
	CALL    printChar
	CALL    setCursor  
	mov     al,' '                  	; delete last char
	mov     bl, 0h                  	; filling the previous position with void
	CALL    printChar
	mov     bx,temp
	ADD     row[bx],3            		; keeping the row no. always ahead
	CMP     row[bx],25           		; as we have
	JNE     returnPAV
	CALL    decLives
	mov     row[bx],1
returnPAV:
    RET  
	
setCursor:                         		;Set Cursor Position
    mov dx,temp
    mov bx,temp
    mov dh, row[bx]
    DEC row[bx]             			; Because we need to delete the previous character
    ;mov    bh,0
    mov ah,02h                  		; Set cursor at dl = column,dh = row
    INT 10h                     
    RET

menu4:
	jmp menu3

printScore:
    mov     BH,00       				; page no.
    mov     AH, 2       				; set cursor position
    mov     DL,11       				; column
    mov     DH,0       					; row
    INT     10h
    mov     AH, 9       				; write character
    mov     BL, 02h     				; color
    mov     BH, 00      				; page no. 0
    mov     CX, 1       				; Number of times to write character
    mov     AL, scoreLSB  				; character to write
    INT     10h
    mov     BH,00
    mov     AH, 2
    mov     DL,10       				; column
    mov     DH,0       					; row
    INT     10h
    mov     AH, 9
    mov     BL, 02h
    mov     BH, 00
    mov     CX, 1       				; Number of times to write character
    mov     AL, scoreMSB
    INT     10h
    ;Check digit
    CMP     scoreLSB, 39h
    JNE     returnPS
    je      incMSB     					; increasing the 2nd digit after 9
returnPS:
    RET     
incMSB:
    mov     scoreLSB, 30h
    ADD     scoreMSB, 1
    RET 
printLives:
    mov     BH,00
    mov     AH,2
    mov     DL,36
    mov     DH,0
    INT     10h
    mov     AH, 9
    mov     BL, 0Ch
    mov     BH, 00
    mov     CX, 1
    mov     AL, lives
    INT     10h
    RET
 
screenClear:							; Clear Screen
	MOV 	AH,2
	MOV 	BH,0
	MOV 	DH,temp2
	MOV 	DL,0
	INT 	10h
	MOV     AH,9
	MOV     BH,0
	MOV 	AL," "
	MOV 	BL,00
	MOV     CX,40
	INT 	10h
	INC 	temp2
	CMP 	temp2,25
	JNE 	screenClear	
	mov 	temp2,0
	RET

decLives:
    DEC     lives
    CMP     lives,48            		; 48 is 0 ASCII code
    JE      endGame
    RET



endGame:
    call screenClear                    ;Clear Screen
	MOV AH, 00H 						;Set video mode
    MOV AL, 13H 						;Mode 13h
    INT 10H
	MOV 	ch, 32       				;hide cursor
	MOV		ah, 1       
	INT 	10h 
    LEA     BP,gameOverShow         	;GAMEOVER!!        
    mov     AH,13h
    mov     BH,0h
    mov     BL,04h
    mov     AL,00h              		;Write mode
    mov     CX,10               		;Number of char in Str.
    mov     DL,15               		;Column
    mov     DH,6                		;Row
    INT     10h
    LEA     BP,showScore            	;Your Score
    mov     AH,13h
    mov     BH,0h
    mov     BL,0Ah
    mov     AL,00h
    mov     CX,6
    mov     DL,15
    mov     DH,9        
    INT     10h
endPrintScore:
    mov     BH,00           			; page no = 0
    mov     AH, 2           			; set cursor position
    mov     DL, 22          			; Column
    mov     DH, 9           			; Row
    INT     10h
    mov     AH, 9           			; print character
    mov     BL, 0Ah         			; color
    mov     BH, 00          			; page no.
    mov     CX, 1           			; Number of times to write character
    mov     AL, scoreMSB      			; character
    INT     10h
    mov     BH,00
    mov     AH, 2           			; set cursor positon
    mov     DL, 23          			; Column
    mov     DH, 9           			; Row
    INT     10h
    mov     AH, 9
    mov     BL, 0Ah
    mov     BH, 00
    mov     CX, 1
    mov     AL, scoreLSB
    INT     10h
    LEA     BP,exitMessage          
    mov     AH,13h
	mov     BH,0h
    mov     BL,0Fh
    mov     AL,0
    mov     CX,34
    mov     DL,6
    mov     DH,12
    INT     10h
    mov     ah, 00h            			; wait for a key
    int     16h
    jmp     menu4

keyMatch:                       
    mov     AH,1                
    INT     16h                 		; Using Intrrupt 16h to get input from keyboard
    JNZ     keyStroke
    RET
keyStroke:                    			; Check when have key input
    mov     AH,0
    INT     16h
    CMP     AL,27               
    JNE     setColumnHigh
    JMP     haltProgram
setColumnHigh:
    mov     keyInput,40             
checkSCH:
    DEC     keyInput
    CMP     keyInput,-1
    JE      goa
    mov     bx,keyInput
    CMP     column[bx],AL
    JNE     checkSCH
    DEC     row[bx]
    mov     AH,02
    mov     dx,keyInput
    mov     dh, row[bx]
    mov     BH,00
    INT 10h
    mov     AL," "
    mov     BH,0
    mov     CX,1
    mov     BL,00h
    mov     AH,9
    INT     10h
    mov     bx,keyInput
    mov     row[bx],1
    mov     column[bx],32
    INC     scoreLSB
goa:	RET

haltProgram:
    mov ah, 4Ch
    mov al, 00
    INT 21h
    RET
END     main
