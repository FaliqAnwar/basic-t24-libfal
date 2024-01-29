SUBROUTINE LOG.TRACKER(yLogFile, yLog, yLogPath, ySwitcher)

* call routine to write simple log tracker for asyn process on t24

    $INSERT I_COMMON
    $INSERT I_EQUATE
    * add more if you need

main:
    GOSUB init
    GOSUB process

    RETURN

init:
    IF NOT(yLogFile) THEN yLogFile = DATE()
    yLogFile = yLogFile : ".log"

    IF NOT(yLogPath) THEN yLogPath = "./"
    
    ffFolder = yLogPath ; fvFolder = ""
    OPEN ffFolder TO fvFolder ELSE
        EXECUTE "CRETAE-FILE " : ffFolder : " TYPE = UD"
        OPEN ffFolder to fvFolder ELSE
            CALL OCOMO("cannot open folder " : ffFolder)
            RETURN
        END
    END

    RETURN

process:
    IF ySwitcher AND ySwitcher EQ "D" THEN
        GOSUB delete.log
        RETURN
    END

    GOSUB write.log
    CLOSE fvFolder

    RETURN

write.log:
    OPENSEQ ffFolder, yLogFile TO fvFolderSeq THEN
        WEOFSEQ fvFolderSeq ;* disable it if you don't want to clear previous log
    END ELSE
        CREATE fvFolderSeq ELSE
            CALL OCOMO("failed to create file " : yLogFile)
            RETURN
        END
    END

    WRITESEQ yLog TO fvFolderSeq ELSE
        CALL OCOMO("failed write to file")
    END

    FLUSH fvFolderSeq ELSE
        CALL OCOMO("can't flush " : yLogFile)
    END

    CLOSESEQ fvFolderSeq

    RETURN

delete.log:
    READ rFile FROM fvFolder, yLogFile THEN
        DELETE fvFolder, yLogFile
    END

    RETURN
END