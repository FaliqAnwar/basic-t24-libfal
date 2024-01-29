SUBROUTINE GET.ID.PROP.ARR(yArr, yProp, yID)

* call routine to return ID for arrangement property table

main:
    GOSUB init
    GOSUB process

    RETURN

init:
    yID = ""

    ffAaArrangementDatedXref = "F.AA.ARRANGEMENT.DATED.XREF" ; fvAaArrangementDatedXref + ""
    CALL OPF(ffAaArrangementDatedXref, fvAaArrangementDatedXref)

    RETURN

process:
    CALL F.READ(ffAaArrangementDatedXref, yArr, rAaArrangementDatedXref, fvAaArrangementDatedXref, "")
    yModule = CHANGE(rAaArrangementDatedXref<1>, @VM, @FM)
    yArray  = CHANGE(rAaArrangementDatedXref<2>, @VM, @FM)

    LOCATE yProp IN yModule SETTING yPos THEN
        yID = yArr : "-" : yModule<yPos> : "-" : yArray<yPos, 1, 1>
    END

    RETURN
END