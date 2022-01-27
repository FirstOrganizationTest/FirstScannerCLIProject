000100 ID DIVISION.
000200 PROGRAM-ID. BWBP01P.
000300**------------------------------------------------------------*
000400**                                                            *
000500**  TITRE          :  BWBP01P                                 *
000600**                                                            *
000700**  TRAITEMENT DES CROS SIPP FERMETURE DE COMPTE              *
000800**                                                            *
000900**  DATE ET AUTEUR : 31/05/2010                               *
001000**                   R.ZITI                                   *
001100**                                                            *
001200**  DESCRIPT. PROG. : CE TRAITEMENT FERME LES CONTRATS BAMCO  *
001300**                    POUR LESQUELS LES COMPTES SUPPORTS ET   *
001400**                    REMISES SONT FERMES                     *
001500**                                                            *
001600**  FONCTIONS PROG. : PSEUDO CODE                             *
001700**                                                            *
001800**  ARCHIT. PROG.   : DESCRIPTION DE LA STRUCTURE DU PROG.    *
001900**                    LES PERFORM, ....                       *
002000**                                                            *
002100**A-INITIALISATION                                            *
002200****  OUVERTURE ET LECTURE                                    *
002300****  ECRITURE ENTETE DU COMPTE RENDU                         *
002400**                                                            *
002500**B-TRAITEMENT                                                *
002600****  FERMETURE DES USAGES COMPTE ASSOCIES                    *
002700**                                                            *
002800**C-FIN-PROGRAMME                                             *
002900** FERMETURE DES FICHIERS                                     *
003000**                                                            *
003100**  PERIODICITE     : JOURNALIERE                             *
003200**                                                            *
003300**  LE OU LES CTI   : LIMEIL                                  *
003400**                                                            *
003500**  ENVIRON. TECHN. : LES TECHNIQUES UTILISéES (SPITAB, DB2...*
003600**                                                            *
003700**  PARAMETRES DE COMPILATION ET COPY UTILISES  : OS390       *
003800**  IRFLUGE1 : ENTETE DE GESTION DU CRO                       *
003900**  IRFLUPP1 : ENTETE APPLICATIVE DU CRO                      *
004000**  A8EMCRF1 : CORPS APPLICATIF CRO COMPTE 01 FERMETURE COMPTE*
004100**  A8EMCRF1   CODITNFLUX = 01
004200**  F2CABND1 ET F2CABNX1 : COPY INCLUDE POUR GESTION ABEND    *
004300**                                                            *
004400**  LOADS UTILISES  : LES DYNAMIQUES OU STATIQUES (INCLUDE)   *
004500**                  * GENABEN3 *                              *
004600**   INCLUDE :                                                *
004700**   ---------                                                *
004800**  - IVWERR3  : ERREURS TECHNIQUES DB2                       *
004900**  - IVPERR2B : ABEND DB2                                    *
005000**  - SQLCA    : ZONE DE COMMUNICATIONS DB2                   *
005100**----------------------------------------------------------- *
005200** SOUS-PROGRAMME APPELES:                                    *
005300** -----------------------                                    *
005400**   GENABEN3 : APPEL POUR GESTION DE L'ABEND (GX0001P)       *
005500**   GENTIMEX : TIMESTAMP SYSTEM (GX0010P)                    *
005600**   F2BB54P  : APPEL A L'ACCESSEUR F2BB54                    *
005700**             RECHERCHE DANS LA TABLE TF2PRGL DU CODE AGENCEL*
005800**! FICHIERS, TABLES: SPI2TAB                                 *
005900**!                   LES DDNAME                              *
006000**  FICHIERS UTILISES :                                       *
006100**  -----------------                                         *
006200**  FICHIERS EN ENTREE :                                      *
006300**   EBWCCPTE  MVS  FLUX CROS SIPP COMPTE FILTRE SUR          *
006400**   CODEFLUX = 1 (FERMETURE COMPTE)                          *
006500**                                                            *
006600**  FICHIERS EN SORTIE :                                      *
006700**   SBWCCPTR  MVS  FICHIER SUIVI COMPTE RENDU                *
006800**                                                            *
006900**  TABLES UTILISEES : TBWCONT, TBWUCPT, TBWINTV              *
007000**  ----------------                                          *
007100**                                                            *
007200**------------------------------------------------------------*
007300** HISTORIQUE :                                               *
007400**============================================================*
007500***************************************************************
007600** COMMENTAIRES DIVERS :                                      *
007700**                                                            *
007800**                                                            *
007900**                                                            *
008000***************************************************************
008100
008200 ENVIRONMENT DIVISION.
008300 CONFIGURATION SECTION.
008400 INPUT-OUTPUT SECTION.
008500 FILE-CONTROL.
008600*-------------
008700**************************************************************
008800*   SELECT FICHIERS EN ENTREE
008900**************************************************************
009000*
009100***  EBWCCPTE FICHIER MVS FLUX CROS FERMETURE COMPTE
009200     SELECT FD-EBWCCPTE ASSIGN TO EBWCCPTE
009300            FILE STATUS IS EBWCCPTE-STATUS.
009400*
009500***  FICHIER PARAMETRE POUR LA DATE DU JOUR
009600     SELECT FD-EBWPARAM ASSIGN TO EBWPARAM
009700            FILE STATUS IS EBWPARAM-STATUS.
009800*
009900*
010000**************************************************************
010100*   SELECT FICHIERS EN SORTIE
010200**************************************************************
010300*
010400**  FICHIERS EN SORTIE :                                      *
010500*
010600
010700**   SBWCCPTR  MVS  FICHIER SUIVI COMPTE RENDU                *
010800***  COMPTE RENDU
010900     SELECT FD-SBWCCPTR ASSIGN TO SBWCCPTR
011000            FILE STATUS IS SBWCCPTR-STATUS.
011100
011200 DATA DIVISION.
011300 FILE SECTION.
011400*-------------
011500**************************************************************
011600*   FD FICHIERS EN ENTREE
011700**************************************************************
011800**   EBWCCPTE  MVS  FLUX CROS FERMETURE COMPTE               *
011900
012000 FD  FD-EBWCCPTE
012100     RECORDING MODE F
012200     BLOCK 0 RECORDS.
012300 01  EBWCCPTE-ENR                        PIC X(5000).
012400
012500***  EBWPARAM FICHIER PARAMETRE EN ENTREE (POUR RECUPERER
012600*                      LA DATE DU JOUR)
012700 FD  FD-EBWPARAM
012800     RECORDING MODE IS F
012900     BLOCK 0 RECORDS.
013000  01 ENR-EBWPARAM PIC X(80).
013100
013200**************************************************************
013300*   FD FICHIERS EN SORTIE
013400**************************************************************
013500
013600**   SBWCCPTR  MVS  FICHIER SUIVI COMPTE RENDU                *
013700 FD  FD-SBWCCPTR
013800     RECORDING MODE F
013900     BLOCK 0 RECORDS.
014000 01  SBWCCPTR-ENR                        PIC X(133).
014100
014200*
014300 WORKING-STORAGE SECTION.
014400*------------------------
014500**************************************************************
014600*   WORKING FICHIERS EN ENTREE
014700**************************************************************
014800**  FICHIERS EN ENTREE :                                      *
014900**   EBWCCPTE  MVS  FLUX CROS FERMETURE COMPTE                *
015000 01  W-EBWCCPTE-ENR.
015100     COPY IRFLUGE1 REPLACING ==:XXX:==  BY ==CPTE==.
015200     COPY IRFLUPP1 REPLACING ==:XXX:==  BY ==CPTE==.
015300  05 W-EBWCCPTE-MAX          PIC X(500).
015400   05 W-EBWCCPTE-CRF1 REDEFINES W-EBWCCPTE-MAX.
015500     COPY A8EMCRF1 REPLACING ==:XX:==   BY ==CPTE==.
015600
015700* FICHIER DE PARAMETRE POUR RECUPERER LA DATE DU JOUR
015800*    05 EBWPARAM-SSAAMMJJ.
015900 01  EBWPARAM-ENR.
016000     05 DTRAIT                              PIC 9(8).
016100     05 EBWPARAM-SSAAMMJJ REDEFINES DTRAIT.
016200           10 EBWPARAM-SSAA     PIC 9(4).
016300           10 EBWPARAM-MM       PIC 9(2).
016400           10 EBWPARAM-JJ       PIC 9(2).
016500     05 FILLER                  PIC X(72).
016600**************************************************************
016700*   WORKING FICHIERS EN SORTIE
016800**************************************************************
016900**  FICHIERS EN SORTIE :                                      *
017000*------------------------------------------------*
017100*    DESCRIPTION FICHIER COMPTE RENDU            *
017200*------------------------------------------------*
017300  01 W-S-LIGNE                   PIC X(133).
017400
017500*----------------------------------------------------------------*
017600*    COMPTEURS COMPTE RENDU FICHIERS EN ENTREE                   *
017700*----------------------------------------------------------------*
017800*EBWCCPTE NOMBRE ENREGISTREMENTS FICHIER FLUX CROS FERMETURE
017900*COMPTE
018000 77  W-CPT-CPTE-ENTREE          PIC 9(10) VALUE ZEROS.
018100
018200*----------------------------------------------------------------*
018300*    COMPTEURS COMPTE RENDU FICHIERS EN SORTIE                   *
018400*----------------------------------------------------------------*
018500**  FICHIERS EN SORTIE :                                      *
018600
018700*------------------------------------------------*
018800*    FILE STATUS                                 *
018900*------------------------------------------------*
019000
019100***  FILE STATUS EBWCCPTE FLUX CROS FERMETURE COMPTE
019200 77  EBWCCPTE-STATUS                     PIC 9(2).
019300     88 EBWCCPTE-OK                              VALUE 00.
019400     88 EBWCCPTE-FINFICHIER                      VALUE 10.
019500
019600***  FILE STATUS SBWCCPTR  MVS  FICHIER SUIVI COMPTE RENDU
019700 77  SBWCCPTR-STATUS                     PIC 9(2).
019800     88 SBWCCPTR-OK                              VALUE 00.
019900     88 SBWCCPTR-FINFICHIER                      VALUE 10.
020000
020100***  FILE STATUS FICHIER PARAMETRE
020200 77  EBWPARAM-STATUS                     PIC 9(2).
020300     88 EBWPARAM-OK                              VALUE 00.
020400     88 EBWPARAM-FINFICHIER                      VALUE 10.
020500
020600* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =*
020700*                                                                *
020800*         V U E S     D B 2      E N     M . A . J O U R         *
020900*                                                                *
021000* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =*
021100     EXEC  SQL  INCLUDE  TBWUCPT  END-EXEC.
021110     EXEC  SQL  INCLUDE  TBWCONT  END-EXEC.
021200     EXEC  SQL  INCLUDE  TBWINTV  END-EXEC.
021300
021400     EXEC  SQL  INCLUDE  SQLCA     END-EXEC.
021500
021600/
021700* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =*
021800*                                                                *
021900*          V U E S     E X T E R N E S     B M C                 *
022000*                                                                *
022100* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =*
022200
022300
022400
022500/
022600* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =*
022700*                                                                *
022800*           C O P Y     D E S     U T I L I T A I R E S          *
022900*                                                                *
023000* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =*
023100
023200*   S Y S T E M E
023300
023400*   VARIABLE DU MODULE  BWDB2
023500
023600     COPY  BWWDB31.
023700
023800
023900*   VARIABLE POUR LA GESTION DES ERREURS TECHNIQUES
024000     EXEC  SQL  INCLUDE IVWERR3  END-EXEC.
024100
024200*------------------------------------------------*
024300*    DESCRIPTION APPEL ABANDON PROGRAMME         *
024400*------------------------------------------------*
024500
024600***  CONSTANTES ET APPEL GX0001P
024700 01  GX0001P                        PIC X(08) VALUE 'GX0001P'.
024800** NOSONAR
024900 01  COPY F2CABND1.
025000 01  COPY F2CABNX1. 
025100
025200*** MESSAGE + CODE ABEND EBWCCPTE FLUX CROS FERMETURE COMPTE
025300 77  WS-MES-EBWCCPTE       PIC X(20)
025400     VALUE ' EBWCCPTE COMPTE    '.
025500
025600*** MESSAGE + CODE ABEND SBWCCPTR  MVS  FICHIER SUIVI COMPTE RENDU
025700***  MESSAGE ET CODE ABEND FICHIER ENTREE DE CRE CREATION SUPPORT
025800 77  WS-MES-SBWCCPTR       PIC X(20)
025900     VALUE ' SBWCCPTR C.RENDU   '.
026000
026100***  MESSAGE ET CODE ABEND CARTE PARAMETRE
026200 77  WS-MES-EBWPARAM        PIC X(20)
026300     VALUE ' CARTE PARAMETRE    '.
026400
026500*************************************************************
026600***  VARIABLES DIVERSES
026700*************************************************************
026800
026900***  NOM PROGRAMME ET PROCESS
027000 01  W-PROGRAMME-ID         PIC X(8)  VALUE 'BWBP01P '.
027100 01  W-PROCESS-ID           PIC X(8)  VALUE 'BWBP01'.
027300***  NUMERO DE CONTRAT
027400 01  WSS-NCN-PREC        PIC  X(007) VALUE SPACES.
027410***  STATUT FERME
027420 01  WSS-F               PIC  X VALUE 'F'.
027430***  USAGE DE TYPE SUPPORT
027440 01  WSS-S               PIC  X VALUE 'S'.
027430***  USAGE DE TYPE REMISES
027440 01  WSS-R               PIC  X VALUE 'R'.
027500***  NOM DU PROGRAMME
027600 01  CST-PGM-ID          PIC  X(008) VALUE 'BWBP01P '.
027700***  INDICATEUR FIN DE CURSEUR
027800 01  WSS-FIN-CSRUCPT     PIC  9(001).
027900     88  FIN-CSRUCPT     VALUE 1.
028000     88  NON-FIN-CSRUCPT VALUE 0.
028100***  INDICATEUR FIN DE CURSEUR
028200 01  LNK-ZNCALCLE.
028300     10  LNK-CDRETCLE    PIC X(001).
028400     10  FILLER          PIC X(011).
028500 01  FILLER REDEFINES LNK-ZNCALCLE.
028600     10  LNK-ZNAGECLE    PIC 9(005).
028700     10  LNK-ZNCPTCLE    PIC 9(007).
028800 01  FRCALCLE            PIC X(8) VALUE 'FRCAL3P '.
028900
027700***  INDICATEUR DE FERMETURE DE CONTRAT
027800 01  WSS-CLS-CONT        PIC  9(1).
027900     88  CLS-CONT        VALUE 1.
028000     88  NOT-CLS-CONT    VALUE 0.
       01 W-0                        PIC 9(2)       VALUE 00.
       01 W-100                      PIC 9(3)       VALUE 100.
029000
029100***  DATE AU FORMAT TIMESTAMP POUR FICHIER PARAMETRE
029200 01  WS-TIMESTAMP-PARAM.
029300     05 TIMESTAMP-PARAM-AAAA          PIC 9(4).
029400     05 SEPARATEUR1                   PIC X(1)  VALUE '-'.
029500     05 TIMESTAMP-PARAM-MM            PIC 9(2).
029600     05 SEPARATEUR2                   PIC X(1)  VALUE '-'.
029700     05 TIMESTAMP-PARAM-JJ            PIC 9(2).
029800     05 SEPARATEUR3                   PIC X(1)  VALUE '-'.
029900     05 TIMESTAMP-PARAM-HH            PIC 9(2)  VALUE 00.
030000     05 SEPARATEUR4                   PIC X(1)  VALUE '.'.
030100     05 TIMESTAMP-PARAM-MN            PIC 9(2)  VALUE 00.
030200     05 SEPARATEUR5                   PIC X(1)  VALUE '.'.
030300     05 TIMESTAMP-PARAM-SS            PIC 9(2)  VALUE 00.
030400     05 SEPARATEUR6                   PIC X(1)  VALUE '.'.
030500     05 TIMESTAMP-PARAM-MMMMMM        PIC 9(6)  VALUE 000000.
030600*------------------------------------------------------------
030700*   CONSTANTES POUR LA MISE EN FORME DE LA DATE
030800*------------------------------------------------------------
030900 01  WSS-HDT.
031000     05  WSS-HDT-SA               PIC  9(004) VALUE ZERO.
031100     05                           PIC  X(001) VALUE '-'.
031200     05  WSS-HDT-MM               PIC  9(002) VALUE ZERO.
031300     05                           PIC  X(001) VALUE '-'.
031400     05  WSS-HDT-JJ               PIC  9(002) VALUE ZERO.
031500     05                           PIC  X(001) VALUE '-'.
031600     05  WSS-HDT-HH               PIC  9(002) VALUE ZERO.
031700     05                           PIC  X(001) VALUE '.'.
031800     05  WSS-HDT-MN               PIC  9(002) VALUE ZERO.
031900     05                           PIC  X(001) VALUE '.'.
032000     05  WSS-HDT-SS               PIC  9(002) VALUE ZERO.
032100     05                           PIC  X(001) VALUE '.'.
032200     05  WSS-HDT-MS               PIC  9(002) VALUE ZERO.
032300
030600*------------------------------------------------------------
030700*   HOST VARIABLES
030800*------------------------------------------------------------
027440 01  H-TCPT-TCP          PIC  X(01).
032400*-------------------
032500 PROCEDURE DIVISION.
032600*-------------------
032700
032800*************************
032900*  ARCHITECTURE PROGRAMME
033000*************************
033100*
033200* OUVERTURE DES FICHIERS ET LECTURE PREMIER ENREGISTREMENT
033300     PERFORM A-INITIALISATION
033400        THRU A-INITIALISATION-FIN.
033500
033600* ECRITURE DU COMPTE RENDU
033700     PERFORM A-ECRITURE-COMPTERENDU
033800        THRU A-ECRITURE-COMPTERENDU-FIN.
033900
034000* FERMETURE USAGES COMPTES POUR LES CROS FERMETURE COMPTE ASSOCIES
034010* A UN CONTRAT COMMERCANT
034100     PERFORM B-TRAITEMENT
034200        THRU B-TRAITEMENT-FIN
034300       UNTIL EBWCCPTE-FINFICHIER.
034400
034500
034600* GESTION FIN DE PROGRAMME
034700     PERFORM C-FIN-PROGRAMME
034800        THRU C-FIN-PROGRAMME-FIN.
034900
035000*    STOP RUN
035100     GOBACK.
035200/
035300******************
035400 A-INITIALISATION.
035500* A INITIALISATION
035600******************
035700**1. FICHIER EBWCCPTE FLUX CROS SIPP COMPTE
035800*    1.1 OUVERTURE
035900     PERFORM A10-EBWCCPTE-OUVRIR
036000        THRU A10-EBWCCPTE-OUVRIR-FIN.
036100*    1.2 LECTURE PREMIER ENREGISTREMENT
036200     PERFORM A15-EBWCCPTE-LIRE
036300        THRU A15-EBWCCPTE-LIRE-FIN.
036400
036500**2. COMPTE RENDU
036600*    2.1 OUVERTURE
036700     PERFORM A80-SBWCCPTR-OUVRIR
036800        THRU A80-SBWCCPTR-OUVRIR-FIN.
036900
037000* 3. FICHIER DE PARAMETRE
037100*    3.1 OUVERTURE
037200     PERFORM A90-EBWPARAM-OUVRIR
037300        THRU A90-EBWPARAM-OUVRIR-FIN.
037400*    3.2 LECTURE-DATE
037500     PERFORM A95-EBWPARAM-LECTURE
037600        THRU A95-EBWPARAM-LECTURE-FIN.
037700
037800     PERFORM     TRT-INIT-DB2P.
037900
038000 A-INITIALISATION-FIN.    EXIT.
038100* FIN INITIALISATION
038200*    EXIT.
038300
038400/
038500 A10-EBWCCPTE-OUVRIR.
038600* 1 OUVERTURE FICHIER EBWCCPTE FLUX CROS FERMETURE COMPTE
038700*** 1.2 OUVERTURE
038800     OPEN INPUT FD-EBWCCPTE.
038900
039000*** 1.2 CONTROLE CODE RETOUR
039100     IF NOT EBWCCPTE-OK
039200        MOVE W-F2CABND-TYP-COB            TO W-F2CABN-MSG-TYPE
039300        MOVE EBWCCPTE-STATUS              TO W-F2CABN-MSG-CODRET
039400        MOVE W-F2CABND-FIC-OPN-COD        TO W-F2CABN-ACTION-CODE
039500        STRING W-F2CABND-FIC-OPN-TXT WS-MES-EBWCCPTE
039600                 DELIMITED BY SIZE INTO W-F2CABN-MSG-LIBEL
039700        PERFORM C-FIN-ANO
039900     END-IF.
040000
040100 A10-EBWCCPTE-OUVRIR-FIN.
040200* FIN OUVERTURE EBWCCPTE
040300      EXIT.
040400
040500*
040600 A15-EBWCCPTE-LIRE.
040700*1 PREMIERE LECTURE FICHIER EBWCCPTE FLUX CROS FERMETURE COMPTE
040800*
040900*** 1.2 LECTURE
041000     READ FD-EBWCCPTE INTO W-EBWCCPTE-ENR
041100     AT END MOVE 10         TO  EBWCCPTE-STATUS
041200     NOT AT END
041300            ADD 1 TO W-CPT-CPTE-ENTREE
041400     END-READ.
041500
041600*** 1.2 CONTROLE CODE RETOUR
041700     IF NOT EBWCCPTE-OK AND NOT EBWCCPTE-FINFICHIER
041800        MOVE W-F2CABND-TYP-COB            TO W-F2CABN-MSG-TYPE
041900        MOVE EBWCCPTE-STATUS              TO W-F2CABN-MSG-CODRET
042000        MOVE W-F2CABND-FIC-LEC-COD        TO W-F2CABN-ACTION-CODE
042100        STRING W-F2CABND-FIC-LEC-TXT WS-MES-EBWCCPTE
042200                 DELIMITED BY SIZE INTO W-F2CABN-MSG-LIBEL
042300        PERFORM C-FIN-ANO
042500     END-IF.
042600
042700 A15-EBWCCPTE-LIRE-FIN.
042800* FIN LECTURE EBWCCPTE
042900     EXIT.
043000
043100/
043200
043300 A80-SBWCCPTR-OUVRIR.
043400***  COMPTE RENDU
043500*
043600* 1. OUVERTURE EN SORTIE
043700*    1.1 OUVERTURE
043800     OPEN OUTPUT FD-SBWCCPTR.
043900*
044000*    1.2 CONTROLE CODE RETOUR
044100     IF NOT SBWCCPTR-OK
044200        MOVE W-F2CABND-TYP-COB            TO W-F2CABN-MSG-TYPE
044300        MOVE SBWCCPTR-STATUS              TO W-F2CABN-MSG-CODRET
044400        MOVE W-F2CABND-FIC-OPN-COD        TO W-F2CABN-ACTION-CODE
044500        STRING W-F2CABND-FIC-OPN-TXT WS-MES-SBWCCPTR
044600                 DELIMITED BY SIZE INTO W-F2CABN-MSG-LIBEL
044700        PERFORM C-FIN-ANO
044900     END-IF.
045000
045100 A80-SBWCCPTR-OUVRIR-FIN.
045200* FIN OUVERTURE SBWCCPTR
045300     EXIT.
045400
045500 A90-EBWPARAM-OUVRIR.
045600***  CARTE PARAMETRE
045700*
045800* 1. OUVERTURE EN ENTREE
045900*    1.1 OUVERTURE
046000     OPEN INPUT FD-EBWPARAM.
046100*
046200*    1.2 CONTROLE CODE RETOUR
046300     IF NOT EBWPARAM-OK
046400        MOVE W-F2CABND-TYP-COB            TO W-F2CABN-MSG-TYPE
046500        MOVE EBWPARAM-STATUS              TO W-F2CABN-MSG-CODRET
046600        MOVE W-F2CABND-FIC-OPN-COD        TO W-F2CABN-ACTION-CODE
046700        STRING W-F2CABND-FIC-OPN-TXT WS-MES-EBWPARAM
046800                 DELIMITED BY SIZE INTO W-F2CABN-MSG-LIBEL
046900        PERFORM C-FIN-ANO
047100     END-IF.
047200
047300 A90-EBWPARAM-OUVRIR-FIN.
047400* FIN OUVERTURE EBWPARAM
047500     EXIT.
047600
047700/
047800
047900 A95-EBWPARAM-LECTURE.
048000* A95-EBWPARAM-LECTURE CARTE PARAMETRE
048100*----------------------------------------------------------------*
048200* LECTURE CARTE PARAMETRE
048300*----------------------------------------------------------------*
048400* LECTURE DU FICHIER PARAMETRE
048500     READ FD-EBWPARAM            INTO EBWPARAM-ENR
048600
048700* CONTROLE CODE RETOUR
048800     IF NOT EBWPARAM-OK AND NOT EBWPARAM-FINFICHIER
048900        MOVE W-F2CABND-TYP-COB            TO W-F2CABN-MSG-TYPE
049000        MOVE EBWPARAM-STATUS              TO W-F2CABN-MSG-CODRET
049100        MOVE W-F2CABND-FIC-LEC-COD        TO W-F2CABN-ACTION-CODE
049200        STRING W-F2CABND-FIC-LEC-TXT WS-MES-EBWPARAM
049300                 DELIMITED BY SIZE INTO W-F2CABN-MSG-LIBEL
049400        PERFORM C-FIN-ANO
049600     END-IF.
049700
049800* ALIMENTATION FORMAT TIMESTAMP
049900     MOVE EBWPARAM-SSAA           TO TIMESTAMP-PARAM-AAAA.
050000     MOVE EBWPARAM-MM             TO TIMESTAMP-PARAM-MM.
050100     MOVE EBWPARAM-JJ             TO TIMESTAMP-PARAM-JJ.
050200
050300 A95-EBWPARAM-LECTURE-FIN.
050400* FIN LECTURE EBWPARAM
050500       EXIT.
050600
050700********************
050800 B-TRAITEMENT.
050900* B TRAITEMENT.
051000********************
051100     PERFORM B10-TRAITEMENT-EBWCCPTE
051200
051300      PERFORM A15-EBWCCPTE-LIRE
051400         THRU A15-EBWCCPTE-LIRE-FIN.
051500
051600
051700 B-TRAITEMENT-FIN.
051800* FIN TRAITEMENT
051900        EXIT.
052000
052100 B10-TRAITEMENT-EBWCCPTE.
052200* B10-TRAITEMENT-EBWCCPTE.
052300     IF NOT EBWCCPTE-FINFICHIER
052400        IF CPTE-FLUX-CODEXTFLUX IN W-EBWCCPTE-ENR NOT = SPACES
052700           MOVE '30002'        TO BANQ-BQE OF TBWUCPT
052800           MOVE CPTE-CODAGE    TO AGEN-AGC OF TBWUCPT
052900           MOVE ZEROS          TO CPTE-NCP OF TBWUCPT
053000           MOVE CPTE-NUMCPTCL  TO CPTE-NCP OF TBWUCPT(5:6)
053001
053010*CALCUL DE LA LETTRE-CLE DE COMPTE
053100           MOVE CPTE-CODAGE    TO LNK-ZNAGECLE
053200           MOVE CPTE-NUMCPTCL  TO LNK-ZNCPTCLE
053300           CALL  FRCALCLE   USING    LNK-ZNCALCLE
053400           MOVE LNK-CDRETCLE   TO  CPTE-NCP OF TBWUCPT(11:1)
053500
053510*RECUPERATION DES CONTRATS ASSOCIES AU COMPTE FERME
053600           EXEC SQL   DECLARE  CBWUCPT
053700              CURSOR   FOR
053800             SELECT   TBWUCPT.CONT_NCN
053900                    , TBWUCPT.TCPT_TCP
054000             FROM     TBWUCPT
054100             WHERE    TBWUCPT.BANQ_BQE = :TBWUCPT.BANQ-BQE
054200             AND      TBWUCPT.AGEN_AGC = :TBWUCPT.AGEN-AGC
054300             AND      TBWUCPT.CPTE_NCP = :TBWUCPT.CPTE-NCP
054400             AND      TBWUCPT.UCPT_DEF_FIN = '9999-12-31'
054500             ORDER BY TBWUCPT.CONT_NCN, TBWUCPT.TCPT_TCP
054600             FOR FETCH ONLY
054700           END-EXEC
054800
054900           EXEC SQL
055000             OPEN CBWUCPT
055100           END-EXEC
055200
055300           SET NON-FIN-CSRUCPT TO TRUE
055400           PERFORM     TRT-UCPT-FETCH
055500
055501*POUR CHAQUE CONTRAT-USAGE-COMPTE
055502
055510*SI COMPTES USAGE SUPPORT ET USAGE REMISE CLOTURES -->
055520*FERMETURE DU CONTRAT
055600           PERFORM UNTIL FIN-CSRUCPT
055700             IF TCPT-TCP OF TBWUCPT = WSS-S OR WSS-R
                        PERFORM  TRT-UCPT-SELEC
                        IF CLS-CONT
   055                     PERFORM  TRT-CONT-MODIF
   055                     PERFORM  TRT-INTV-INSERT
                        END-IF
055741             END-IF
055742
055743*FERMETURE DU LIEN ENTRE CONTRAT ET COMPTE RATTACHE
055744*ENREGISTREMENT DANS LE FICHIER COMPTE-RENDU
055750             PERFORM     TRT-UCPT-MODIF
055770             PERFORM    B-ECRITURE-TRACE
055780
055800             PERFORM     TRT-UCPT-FETCH
056300           END-PERFORM
056310
056400           EXEC SQL
056500             CLOSE CBWUCPT
056600           END-EXEC
056700        END-IF
056900     END-IF
057000        EXIT.
057100
057200 TRT-INTV-INSERT.
057300*---------------
057400*    IF PRESENCE-SUPPORT
057500        MOVE 'O' TO INTV-TON-AV OF TBWINTV
057600*    ELSE
057700*       MOVE 'N' TO INTV-TON-AV OF TBWINTV
057800*    END-IF
057900
058000     MOVE '20' TO MINT-MIN OF TBWINTV
058100
058200     MOVE CONT-NCN OF TBWUCPT TO CONT-NCN OF TBWINTV
058300* L'HORODATE D'INTERVENTION EST AUGMENTEE D'UN MILLIONIEME DE
058400* SECONDE A CHAQUE OCCURRENCE POUR EVITER LES DOUBLONS
058500     ADD 1                  TO WSS-HDT-MS
058600     MOVE WSS-HDT           TO INTV-HDT OF TBWINTV
058700     MOVE DB2P-CURRENT-DATE TO INTV-DEF OF TBWINTV
058800     MOVE 'B240'            TO INTV-INV OF TBWINTV
058900
059000     INITIALIZE INTV-TXT-TEXT OF TBWINTV
059100     MOVE 1 TO INTV-TXT-LEN OF TBWINTV
059200
059300     STRING
059400          'FERMETURE SIPP COMPTE '
059500           CPTE-CODAGE '/' CPTE-NUMCPTCL
059600           LNK-CDRETCLE '/'
059700           DELIMITED  BY  SIZE
059800           INTO          INTV-TXT-TEXT  OF  TBWINTV
059900           WITH POINTER  INTV-TXT-LEN   OF  TBWINTV
060000       END-STRING
060100
060200     EXEC SQL
060300        INSERT INTO TBWINTV
060400               (INTV_HDT,
060500                INTV_INV,
060600                MINT_MIN,
060700                CONT_NCN,
060800                INTV_DEF,
060900                INTV_TON_AV,
061000                INTV_TXT)
061100        VALUES (:TBWINTV.INTV-HDT,
061200                :TBWINTV.INTV-INV,
061300                :TBWINTV.MINT-MIN,
061400                :TBWINTV.CONT-NCN,
061500                :TBWINTV.INTV-DEF,
061600                :TBWINTV.INTV-TON-AV,
061700                :TBWINTV.INTV-TXT)
061800     END-EXEC
061900
062000     MOVE 'TBWINTV '          TO DB2P-LABEL
062100     MOVE 'INSERT'            TO DB2P-COMMAND
062200
062300     PERFORM DB2P-CHECK-RESULT
062400*-----
062500     .
062600
062700 TRT-UCPT-FETCH.
062800* TRT UCPT FETCH
062900     EXEC SQL
063000        FETCH CBWUCPT
063100        INTO :TBWUCPT.CONT-NCN,
063200             :TBWUCPT.TCPT-TCP
063300     END-EXEC
063400
063500     MOVE       'SELECT TBWUCPT '      TO DB2P-LABEL
063600     MOVE       'FETCH'                TO DB2P-COMMAND
063700     MOVE       'TBWUCPT '             TO DB2P-OBJECT
063800     PERFORM    DB2P-CHECK-RESULT.
063900     IF NOT DB2P-FOUND
064000        SET FIN-CSRUCPT TO TRUE
064100     END-IF
064200     .
064300
064400 TRT-UCPT-MODIF.
064500* MISE A JOUR DE LA TABLE TBWUCPT
064600     MOVE DB2P-CURRENT-DATE TO UCPT-DEF-FIN OF TBWUCPT
064700     EXEC SQL
064800        UPDATE TBWUCPT
064900          SET  UCPT_DEF_FIN = :TBWUCPT.UCPT-DEF-FIN
065000          WHERE  AGEN_AGC     = :TBWUCPT.AGEN-AGC
065100          AND    BANQ_BQE     = :TBWUCPT.BANQ-BQE
065200          AND    CPTE_NCP     = :TBWUCPT.CPTE-NCP
065300          AND    CONT_NCN     = :TBWUCPT.CONT-NCN
065400          AND    TCPT_TCP     = :TBWUCPT.TCPT-TCP
065500     END-EXEC
065600
065700     MOVE       'UPDATE TBWUCPT '      TO DB2P-LABEL
065800     MOVE       'UPDATE'               TO DB2P-COMMAND
065900     MOVE       'TBWUCPT '             TO DB2P-OBJECT
066000     PERFORM    DB2P-CHECK-RESULT
066100     PERFORM    DB2P-COMMIT.
066101
064400 TRT-UCPT-SELEC.
064500* RECHERCHE SI LE COMPTE SUPPORT (DANS LE CAS D'UNE FERMETURE DE
      * COMPTE REMISE) OU LE COMPTE REMISE (DANS LE CAS D'UNE FERMETURE
      * DE COMPTE SUPPORT) EST FERMé.

064600     MOVE DB2P-CURRENT-DATE   TO UCPT-DEF-FIN OF TBWUCPT
           IF TCPT-TCP OF TBWUCPT = WSS-S
              MOVE WSS-R                     TO H-TCPT-TCP
           ELSE
              MOVE WSS-S                     TO H-TCPT-TCP
           END-IF

064700     EXEC SQL
064800        SELECT CONT_NCN
                INTO :TBWUCPT.CONT-NCN
                FROM TBWUCPT
065300          WHERE  CONT_NCN     = :TBWUCPT.CONT-NCN
065400          AND    TCPT_TCP     = :H-TCPT-TCP
                AND    UCPT_DEF_FIN > :TBWUCPT.UCPT-DEF-FIN
065500     END-EXEC
065600
           IF SQLCODE NOT = W-0
              IF SQLCODE = W-100
                 SET CLS-CONT TO TRUE
              ELSE
                 MOVE       'SELECT CONTRAT '      TO DB2P-LABEL
                 MOVE       'SELECT'               TO DB2P-COMMAND
                 MOVE       'TBWUCPT '             TO DB2P-OBJECT
                 PERFORM    DB2P-CHECK-RESULT
                 PERFORM    DB2P-COMMIT
              END-IF
           ELSE
066101        SET NOT-CLS-CONT TO TRUE
066105     END-IF.

066106 TRT-CONT-MODIF.
066110* MISE A JOUR DE LA TABLE TBWCONT
066120     MOVE DB2P-CURRENT-DATE   TO CONT-DEF-ETC OF TBWCONT
066121     MOVE CONT-NCN OF TBWUCPT TO CONT-NCN OF TBWCONT
066122     MOVE WSS-F               TO CONT-ETC OF TBWCONT
066130     EXEC SQL
066140        UPDATE TBWCONT
066150          SET  CONT_DEF_ETC = :TBWCONT.CONT-DEF-ETC,
066151                 CONT_ETC   = :TBWCONT.CONT-ETC
066190          WHERE  CONT_NCN   = :TBWCONT.CONT-NCN
066192     END-EXEC
066193
066194     MOVE       'UPDATE TBWCONT '      TO DB2P-LABEL
066195     MOVE       'UPDATE'               TO DB2P-COMMAND
066196     MOVE       'TBWCONT '             TO DB2P-OBJECT
066197     PERFORM    DB2P-CHECK-RESULT
066198     PERFORM    DB2P-COMMIT.
066400
066500******************************************************************
066600*   B-ECRITURE TRACE
066700******************************************************************
066800
066900 B-ECRITURE-TRACE.
067000* B-ECRITURE-TRACE.
067100*-----------------------
067200     MOVE SPACES TO SBWCCPTR-ENR
067300     STRING
067400          CONT-NCN OF TBWUCPT
067500          '/'
067600          TCPT-TCP OF TBWUCPT
067700          '/'
067800          AGEN-AGC OF TBWUCPT
067900          '/'
068000          CPTE-NCP OF TBWUCPT
068100       DELIMITED  BY  SIZE
068200       INTO SBWCCPTR-ENR
068300     END-STRING
068400     PERFORM ECRITURE-LIGNE.
068500
068600 B-ECRITURE-TRACE-FIN.
068700* FIN ECRITURE COMPTE RENDU
068800        EXIT.
068900******************************************************************
069000*   C-ECRITURE COMPTE RENDU
069100******************************************************************
069200
069300 A-ECRITURE-COMPTERENDU.
069400* A-ECRITURE-COMPTERENDU.
069500*-----------------------
069600* ALIMENTATION DE LA DATE
069700     MOVE SPACES TO SBWCCPTR-ENR
069800     STRING 'FERMETURES DE COMPTES SIPP LE '
069900          EBWPARAM-JJ '/'
070000          EBWPARAM-MM '/'
070100          EBWPARAM-SSAA
070200       DELIMITED  BY  SIZE
070300       INTO SBWCCPTR-ENR
070400     END-STRING
070500     PERFORM ECRITURE-LIGNE.
070600
070700
070800 A-ECRITURE-COMPTERENDU-FIN.
070900* FIN ECRITURE COMPTE RENDU
071000        EXIT.
071100
071200 ECRITURE-LIGNE.
071300*---------------
071400* ECRITURE FICHIER COMPTE RENDU
071500      WRITE SBWCCPTR-ENR
071600
071700*** CONTROLE STATUT FICHIER
071800      IF NOT SBWCCPTR-OK
071900        MOVE W-F2CABND-TYP-COB            TO W-F2CABN-MSG-TYPE
072000        MOVE SBWCCPTR-STATUS              TO W-F2CABN-MSG-CODRET
072100        MOVE W-F2CABND-FIC-ECR-COD        TO W-F2CABN-ACTION-CODE
072200        STRING W-F2CABND-FIC-ECR-TXT WS-MES-SBWCCPTR
072300                 DELIMITED BY SIZE INTO W-F2CABN-MSG-LIBEL
072400        PERFORM C-FIN-ANO
072600      END-IF.
072700
072800 ECRITURE-LIGNE-FIN.
072900* FIN ECRITURE LIGNE
073000        EXIT.
073100
073200******************************************************************
073300*   C-FIN-PROGRAMME
073400******************************************************************
073500 C-FIN-PROGRAMME.
073600*--------------------
073700       EXIT.
073800*----------------
073900
074000**  FICHIERS EN ENTREE :
074100*FERMETURE ET CONTROLE STATUS FICHIERS EN ENTREE
074200
074300 C05-EBWPARAM-FERMETURE.
074400* EBWPARAM : FICHIER PARAMETRE POUR LA DATE
074500* FERMETURE FICHIER EBWPARAM
074600*  MVS FICHIER PARAMETRE POUR LA DATE
074700      CLOSE FD-EBWPARAM.
074800
074900* 1.CONTROLE STATUS EBWPARAM
075000
075100      IF EBWPARAM-STATUS NOT = ZERO
075200        MOVE W-F2CABND-TYP-COB            TO W-F2CABN-MSG-TYPE
075300        MOVE EBWPARAM-STATUS              TO W-F2CABN-MSG-CODRET
075400        MOVE W-F2CABND-FIC-CLO-COD        TO W-F2CABN-ACTION-CODE
075500        STRING W-F2CABND-FIC-CLO-TXT WS-MES-EBWPARAM
075600                 DELIMITED BY SIZE INTO W-F2CABN-MSG-LIBEL
075700        PERFORM C-FIN-ANO
075900      END-IF.
076000
076100 C10-EBWCCPTE-FERMETURE.
076200* FERMETURE FICHIER FLUX CROS SIPP COMPTE
076300      CLOSE FD-EBWCCPTE.
076400
076500*** CONTROLE STATUS FICHIER FLUX CROS SIPP COMPTE
076600      IF EBWCCPTE-STATUS NOT = ZERO
076700        MOVE W-F2CABND-TYP-COB            TO W-F2CABN-MSG-TYPE
076800        MOVE EBWCCPTE-STATUS              TO W-F2CABN-MSG-CODRET
076900        MOVE W-F2CABND-FIC-CLO-COD        TO W-F2CABN-ACTION-CODE
077000        STRING W-F2CABND-FIC-CLO-TXT WS-MES-EBWCCPTE
077100                 DELIMITED BY SIZE INTO W-F2CABN-MSG-LIBEL
077200        PERFORM C-FIN-ANO
077400      END-IF.
077500
077600      PERFORM     DB2P-FINAL.
077700
077800
077900 C-FIN-PROGRAMME-FIN.
078000* FIN DE CLOTURE DU PROGRAMME
078100     EXIT.
078200*----------------------------------------------------------------*
078300 TRT-INIT-DB2P.
078400*TRT INIT DB2P.
078500     EXEC  SQL  WHENEVER  SQLWARNING  CONTINUE  END-EXEC
078600     EXEC  SQL  WHENEVER  NOT FOUND   CONTINUE  END-EXEC
078700
078800     INITIALIZE  DB2P-INTERFACE
078900     SET  DB2P-ERRMODE-SOFT     TO  TRUE
079000     SET  DB2P-NOT-RESTARTABLE  TO  TRUE
079100     SET  DB2P-TRTS-NO          TO  TRUE
079200     SET  DB2P-TRACE-OFF        TO  TRUE
079300     PERFORM  DB2P-INIT
079400
079500     MOVE DB2P-CURRENT-TMST       TO WSS-HDT
079600     MOVE ZERO                    TO WSS-HDT-MS
079700*-----
079800     .
079900*================================================================*
080000* INITIALISATIONS
080100*================================================================*
080200 DB2P-INIT.
080300* ----------
080400     MOVE CST-PGM-ID  TO DB2P-PGMID
080500
080600     MOVE DB2P-FONCTION-INIT TO DB2P-FONCTION
080700     CALL DB2P-DB2P-ID USING DB2P-INTERFACE
080800     .
080900
081000*================================================================*
081100* TRAITEMENT DES ERREURS
081200*================================================================*
081300 DB2P-CHECK-RESULT.
081400* ------------------
081500     MOVE SQLCODE TO DB2P-SQLCODE
081600     MOVE SQLCA   TO DB2P-SQLCA
081700     MOVE DB2P-FONCTION-CHECK TO DB2P-FONCTION
081800     CALL DB2P-DB2P-ID USING DB2P-INTERFACE
081900     .
082000
082100*================================================================*
082200* TRAITEMENT DES COMMITS INTERMEDIAIRES
082300*================================================================*
082400 DB2P-COMMIT.
082500* ------------
082600     MOVE DB2P-FONCTION-COMMIT TO DB2P-FONCTION
082700     CALL DB2P-DB2P-ID USING DB2P-INTERFACE
082800     .
082900
083000*================================================================*
083100* FIN DE TRAITEMENT
083200*================================================================*
083300 DB2P-FINAL.
083400* -------------
083500     MOVE DB2P-FONCTION-FINAL TO DB2P-FONCTION
083600     CALL DB2P-DB2P-ID USING DB2P-INTERFACE
083700     .
083701*================================================================*
083702* FIN ANORMALE
083703*================================================================*
083704 C-FIN-ANO.
083705* -------------
083710     CALL GX0001P   USING W-F2CABN-ACTION
083720                          W-F2CABN-MSG.
083800