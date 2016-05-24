<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="xs xi tei"
    version="2.0">
    
    <!-- izhodiščni dokument je izbrani teiCorpus iz direktorija SlovParl/teiCorpus  -->
    
    <xsl:output method="xml" indent="yes"/>
    
    <!-- vstavi pot do izhodiščnega direktorija, v katerem boš kreiral child direktorije in shranil result-document -->
    <xsl:param name="path2folder">/Users/administrator/Documents/moje/SlovParl/clarin/edition01/</xsl:param>
    
    <!-- vstavi xpath do toc dokumenta za kazalo vsebine (celoten korpus) -->
    <xsl:param name="toc-document">../teiCorpus/toc_ZbZdruDel-Sk-11.xml</xsl:param>
    
    <!-- primerno dopolni in popravi vsebino corpus header -->
    <xsl:param name="corpus-header">
        <teiHeader>
            <fileDesc>
                <titleStmt>
                    <title>title of corpus</title>
                    <author>author</author>
                </titleStmt>
                <publicationStmt>
                    <p>Publication Information</p>
                </publicationStmt>
                <sourceDesc>
                    <p>Information about the source</p>
                </sourceDesc>
            </fileDesc>
        </teiHeader>
    </xsl:param>
    
    <xsl:param name="idKomentatorja">komentator</xsl:param>
    
    <xsl:variable name="mandati">
        <!--<mandat from="" to="">Sk-01</mandat>
        <mandat from="" to="">Sk-02</mandat>
        <mandat from="" to="">Sk-03</mandat>
        <mandat from="" to="">Sk-04</mandat>
        <mandat from="" to="">Sk-05</mandat>
        <mandat from="" to="">Sk-06</mandat>
        <mandat from="" to="">Sk-07</mandat>
        <mandat from="" to="">Sk-08</mandat>
        <mandat from="" to="">Sk-09</mandat>
        <mandat from="" to="">Sk-10</mandat>-->
        <mandat from="1990-05-07" to="1992-12-22">Sk-11</mandat>
        <mandat from="1992-12-23" to="1996-11-27">DZ-01</mandat>
        <mandat from="1996-11-28" to="2000-10-26">DZ-02</mandat>
        <mandat from="2000-10-27" to="2004-10-21">DZ-03</mandat>
        <mandat from="2004-10-22" to="2008-10-14">DZ-04</mandat>
        <mandat from="2008-10-15" to="2011-12-15">DZ-05</mandat>
        <mandat from="2011-12-16" to="2014-07-31">DZ-06</mandat>
    </xsl:variable>
    
    <xsl:template match="tei:teiCorpus">
        <xsl:for-each select="tei:TEI/tei:text/tei:body/tei:div/tei:div">
            <xsl:variable name="docDate-prvi" select="tei:docDate/tei:date[1]/@when"/>
            <xsl:variable name="direktorijMandat">
                <xsl:for-each select="$mandati/tei:mandat">
                    <xsl:if test="xs:date(@from) eq xs:date($docDate-prvi) or xs:date(@from) lt xs:date($docDate-prvi)">
                        <xsl:if test="xs:date(@to) eq xs:date($docDate-prvi) or xs:date(@to) gt xs:date($docDate-prvi)">
                            <xsl:value-of select="."/>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="zbor" select="tokenize(substring-after(parent::tei:div/@ana,'#PAR.'),' ')[1]"/>
            <xsl:variable name="kategorijaVrsteSeje" select="substring-after(@ana,'#PAR.')"/>
            <!-- Če je Seja, dobi črko s, če pa je zasedanje, dobi črko z -->
            <xsl:variable name="vrstaSeje">
                <xsl:choose>
                    <xsl:when test="$kategorijaVrsteSeje = 'Seja'">s</xsl:when>
                    <xsl:otherwise>z</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="stSeje">
                <xsl:choose>
                    <xsl:when test="string-length(@n) = 1">
                        <xsl:value-of select="concat('00',@n)"/>
                    </xsl:when>
                    <xsl:when test="string-length(@n) = 2">
                        <xsl:value-of select="concat('0',@n)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@n"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <!-- za kasneje v variablo shranim timeline -->
            <xsl:variable name="timeline">
                <xsl:copy-of select="tei:timeline" copy-namespaces="no"/>
            </xsl:variable>
            <!-- za kasneje v variablo shranim id predsedujočih oseb -->
            <xsl:variable name="predsedujoci">
                <xsl:for-each select="tei:castList/tei:castItem/tei:actor">
                    <xsl:variable name="actorId" select="@xml:id"/>
                    <preds>
                        <xsl:value-of select="distinct-values(//tei:sp[substring-after(@corresp,'#') = $actorId]/substring-after(@who,'sp:'))"/>
                    </preds>
                </xsl:for-each>
            </xsl:variable>
            
            <!-- govore sp odstranim iz div hierarhije in njihovim p, speaker, ad in stage dodam atribute who (iz sp) in div-id (iz parent div) -->
            <xsl:variable name="govori-var1">
                <xsl:apply-templates select="tei:div/tei:div" mode="govori-1"/>
            </xsl:variable>
            <!-- sp, ki so bili prej ločeni zaradi vsebinskih div, združim glede na govorca -->
            <xsl:variable name="govori-var2">
                <xsl:for-each-group select="$govori-var1/*" group-starting-with="tei:sp[tei:speaker]">
                    <div>
                        <xsl:for-each select="current-group()">
                            <xsl:copy-of select="."/>
                        </xsl:for-each>
                    </div>
                </xsl:for-each-group>
            </xsl:variable>
            <!-- poenotim imena elementov v u (razen p/stage) -->
            <xsl:variable name="govori-var3">
                <!-- sem moral dati v variablo root element, ker drugače ni mogoče uporabljati xsl:copy in posledično
                        split-element v naslednji variabli ne deluje -->
                <root>
                    <!-- najprej dodam vsebino, ki je vedno pred prvim div/div/sp -->
                    <div>
                        <anchor xml:id="{tei:stage/tei:time[@from]/@xml:id}" n="{substring-before(tei:stage/tei:time/@from,'T')}"/>
                        <u who="{concat('#',$idKomentatorja)}"><xsl:value-of select="normalize-space(../tei:head)"/></u>
                        <u who="{concat('#',$idKomentatorja)}"><xsl:value-of select="normalize-space(tei:head)"/></u>
                        <u who="{concat('#',$idKomentatorja)}"><xsl:value-of select="normalize-space(tei:docDate)"/></u>
                        <u who="{concat('#',$idKomentatorja)}"><xsl:value-of select="normalize-space(tei:castList)"/></u>
                        <u who="{concat('#',$idKomentatorja)}"><xsl:value-of select="normalize-space(tei:stage)"/></u>
                    </div>
                    <!-- procesiram prejšnjo variablo -->
                    <xsl:apply-templates select="$govori-var2" mode="govori-var3-ciscenje"/>
                </root>
            </xsl:variable>
            <!-- prejšnji p/stage zaznamujem kot ločen del govora (u komentatorja) -->
            <xsl:variable name="govori-var4">
                <xsl:apply-templates select="$govori-var3" mode="govori-var4-razdruzevanje"/>
            </xsl:variable>
            <!-- vse u/u in u/stage pretvorim v samostojne u (nadaljevanje prejšnje variable) -->
            <xsl:variable name="govori-var5">
                <xsl:apply-templates select="$govori-var4" mode="govori-var5-ciscenje"/>
            </xsl:variable>
            <!-- dodani xml:id vsem elementom v variabli (glede na position() ) -->
            <xsl:variable name="govori-var6">
                <xsl:apply-templates select="$govori-var5" mode="govori-var6-doda_id"/>
            </xsl:variable>
            <!-- elementi u dobijo v atributu n datum prvega predhodnega anchor/@n (ki ga je prej dobil od time/@from) -->
            <xsl:variable name="govori-var8">
                <xsl:apply-templates select="$govori-var6" mode="govori-var-8-datum"/>
            </xsl:variable>
            <!-- zadnji anchor/@, ki ima drugačen datum kot div znotraj katerega se nahaja, premaknem v naslednji div -->
            <xsl:variable name="govori-var8b">
                <xsl:apply-templates select="$govori-var8" mode="govori-var-8b-premakni_anchor"/>
            </xsl:variable>
            
            <!-- vsebino razdelim v skupine z istim dnevom -->
            <xsl:for-each-group select="$govori-var8b/tei:div" group-by="tei:u[1]/@n">
                <xsl:variable name="pozicija" select="position()"/>
                <xsl:variable name="stSkupine" >
                    <xsl:choose>
                        <xsl:when test="$pozicija lt 10">
                            <xsl:value-of select="concat('0',$pozicija)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$pozicija"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <!-- vsebino shranim v variablo (jo uporabim za konstrukcijo kazala in timeline -->
                <xsl:variable name="govori-var10">
                    <xsl:for-each select="current-group()">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </xsl:variable>
                <!-- na koncu pošistim odvečne corresp in n atribute iz elementov u in ancor -->
                <xsl:variable name="govori-var11">
                    <xsl:apply-templates select="$govori-var10" mode="govori-var-11-ciscenje"/>
                </xsl:variable>
                <xsl:variable name="path2document" select="concat($path2folder,$direktorijMandat,'/',current-grouping-key(),'-',$zbor,'-',$vrstaSeje,$stSeje,'-',$stSkupine,'/')"/>
                <xsl:variable name="document-text" select="concat($path2document,'text_structure.xml')"/>
                <xsl:variable name="document-corpus-header" select="concat($path2document,'corpus-header.xml')"/>
                <xsl:variable name="document-header" select="concat($path2document,'header.xml')"/>
                <xsl:result-document href="{$document-text}">
                    <teiCorpus>
                        <xsl:text disable-output-escaping="yes"><![CDATA[<xi:include xmlns:xi="http://www.w3.org/2001/XInclude" href="corpus-header.xml"/>]]></xsl:text>
                        <xsl:result-document href="{$document-corpus-header}">
                            <xsl:copy-of select="$corpus-header"/>
                        </xsl:result-document>
                        <TEI>
                            <xsl:text disable-output-escaping="yes"><![CDATA[<xi:include xmlns:xi="http://www.w3.org/2001/XInclude" href="header.xml"/>]]></xsl:text>
                            <xsl:result-document href="{$document-header}">
                                <teiHeader>
                                    <fileDesc>
                                        <titleStmt>
                                            <title/>
                                            <author/>
                                        </titleStmt>
                                        <publicationStmt>
                                            <p/>
                                        </publicationStmt>
                                        <sourceDesc>
                                            <p/>
                                        </sourceDesc>
                                    </fileDesc>
                                    <profileDesc>
                                        <particDesc>
                                            <!-- vstavim povezave na govorove predsednika in podpredsednika -->
                                            <xsl:for-each select="$predsedujoci/tei:preds">
                                                <xsl:variable name="predsId" select="."/>
                                                <person role="president" sameAs="{concat('#',.)}">
                                                    <linkGrp>
                                                        <xsl:for-each select="$govori-var10//tei:u[substring-after(@who,'#') = $predsId]">
                                                            <ptr target="{concat('#',@xml:id)}"/>
                                                        </xsl:for-each>
                                                    </linkGrp>
                                                </person>
                                            </xsl:for-each>
                                        </particDesc>
                                    </profileDesc>
                                </teiHeader>
                            </xsl:result-document>
                            <text xml:lang="sl">
                                <front>
                                    <div type="contents">
                                        <list>
                                            <xsl:for-each-group select="$govori-var10//tei:u" group-by="@ana">
                                                <item xml:id="{concat('toc-item',position())}">
                                                    <xsl:variable name="naslov-kazalo">
                                                        <xsl:for-each select="document($toc-document)//tei:item[substring-after(@corresp,'corp:') = current-grouping-key()]">
                                                            <title>
                                                                <xsl:value-of select="normalize-space(tei:p[1])"/>
                                                            </title>
                                                        </xsl:for-each>
                                                    </xsl:variable>
                                                    <!-- v kazalu celotnega korpusa se lahko isti item/@cooresp nahajajo v razližnih vsebinskih sklopih
                                                    (imajo atribut synche, ki jih povezuje med seboj preko xml:id) -->
                                                    <title>
                                                        <xsl:value-of select="$naslov-kazalo/tei:title[1]"/>
                                                    </title>
                                                    <xsl:for-each select="current-group()">
                                                        <ptr target="{concat('#',@xml:id)}"/>
                                                    </xsl:for-each>
                                                </item>
                                            </xsl:for-each-group>
                                        </list>
                                    </div>
                                </front>
                                <body>
                                    <!-- prečiščim originalni timeline glede na isti datum -->
                                    <xsl:variable name="timeline-when">
                                        <xsl:for-each select="$timeline//tei:when[substring-before(@absolute,'T') = current-grouping-key()]">
                                            <xsl:copy-of select="."/>
                                        </xsl:for-each>
                                    </xsl:variable>
                                    <timeline origin="{$timeline-when/tei:when[1]/concat('#',@xml:id)}" unit="s">
                                        <xsl:for-each select="$timeline-when//tei:when">
                                            <xsl:copy-of select="."/>
                                        </xsl:for-each>
                                    </timeline>
                                    <!-- kopiram vsebino govorov iz zadnje govor variable -->
                                    <xsl:copy-of select="$govori-var11"/>
                                </body>
                            </text>
                        </TEI>
                    </teiCorpus>
                </xsl:result-document>
            </xsl:for-each-group>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="tei:sp" mode="govori-1">
        <xsl:variable name="sp-who" select="substring-after(@who,'sp:')"/>
        <xsl:variable name="div-id" select="parent::tei:div/@xml:id"/>
        <sp>
            <xsl:apply-templates mode="govori-2">
                <xsl:with-param name="sp-who" select="$sp-who"/>
                <xsl:with-param name="div-id" select="$div-id"/>
            </xsl:apply-templates>
        </sp>
    </xsl:template>
    
    <xsl:template match="tei:stage" mode="govori-1">
        <xsl:variable name="sp-who" select="substring-after(@who,'sp:')"/>
        <xsl:variable name="div-id" select="parent::tei:div/@xml:id"/>
        <xsl:choose>
            <xsl:when test=".[@type = 'time']">
                <p who="{concat('#',$idKomentatorja)}" divId="{$div-id}">
                    <xsl:value-of select="normalize-space(.)"/>
                </p>
                <xsl:if test="tei:time/@to">
                    <anchor xml:id="{tei:time[@to]/@xml:id}"/>
                </xsl:if>
                <xsl:if test="tei:time/@from">
                    <anchor xml:id="{tei:time[@from]/@xml:id}" n="{substring-before(tei:time/@from,'T')}"/>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <p who="{concat('#',$idKomentatorja)}" divId="{$div-id}">
                    <xsl:value-of select="normalize-space(.)"/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <xsl:template match="tei:speaker" mode="govori-2">
        <xsl:param name="div-id"/>
        <speaker who="{concat('#',$idKomentatorja)}" divId="{$div-id}">
            <xsl:value-of select="normalize-space(.)"/>
        </speaker>
    </xsl:template>
    
    <xsl:template match="tei:p" mode="govori-2">
        <xsl:param name="sp-who"/>
        <xsl:param name="div-id"/>
        <p who="{concat('#',$sp-who)}" divId="{$div-id}">
            <xsl:apply-templates mode="govori-3">
                <xsl:with-param name="sp-who" select="$sp-who"/>
                <xsl:with-param name="div-id" select="$div-id"/>
            </xsl:apply-templates>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:ab" mode="govori-2">
        <xsl:param name="sp-who"/>
        <xsl:param name="div-id"/>
        <p who="{concat('#',$sp-who)}" divId="{$div-id}">
            <xsl:value-of select="normalize-space(.)"/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:stage" mode="govori-2">
        <xsl:param name="div-id"/>
        <xsl:choose>
            <xsl:when test=".[@type = 'time']">
                <p who="{concat('#',$idKomentatorja)}" divId="{$div-id}">
                    <xsl:value-of select="normalize-space(.)"/>
                </p>
                <xsl:if test="tei:time/@to">
                    <anchor xml:id="{tei:time[@to]/@xml:id}"/>
                </xsl:if>
                <xsl:if test="tei:time/@from">
                    <anchor xml:id="{tei:time[@from]/@xml:id}" n="{substring-before(tei:time/@from,'T')}"/>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <p who="{concat('#',$idKomentatorja)}" divId="{$div-id}">
                    <xsl:value-of select="normalize-space(.)"/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:stage" mode="govori-3">
        <xsl:param name="div-id"/>
        <stage who="{concat('#',$idKomentatorja)}" divId="{$div-id}">
            <xsl:value-of select="."/>
        </stage>
    </xsl:template>
    
    <xsl:template match="tei:div" mode="govori-var3-ciscenje">
        <div>
            <xsl:apply-templates mode="govori-var3-ciscenje"/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:sp" mode="govori-var3-ciscenje">
        <xsl:apply-templates mode="govori-var3-ciscenje"/>
    </xsl:template>
    
    <xsl:template match="tei:speaker" mode="govori-var3-ciscenje">
        <u who="{@who}" divId="{@divId}">
            <xsl:value-of select="normalize-space(.)"/>
        </u>
    </xsl:template>
    
    <xsl:template match="tei:anchor" mode="govori-var3-ciscenje">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    <xsl:template match="tei:p" mode="govori-var3-ciscenje">
        <u who="{@who}" divId="{@divId}">
            <xsl:apply-templates mode="govori-var3-ciscenje2"/>
        </u>
    </xsl:template>
    
    <xsl:template match="tei:stage" mode="govori-var3-ciscenje2">
        <stage>
            <xsl:value-of select="."/>
        </stage>
    </xsl:template>
    
    <xsl:template match="node()|@*" mode="govori-var4-razdruzevanje">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" mode="govori-var4-razdruzevanje"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/*" mode="govori-var4-razdruzevanje">
        <xsl:apply-templates mode="govori-var4-razdruzevanje"/>
    </xsl:template>
    
    <xsl:template match="tei:u[tei:stage]/text()" mode="govori-var4-razdruzevanje">
        <u><xsl:copy-of select="."/></u>
    </xsl:template>
    
    <xsl:template match="node()|@*" mode="govori-var5-ciscenje">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" mode="govori-var5-ciscenje"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:u[tei:stage]" mode="govori-var5-ciscenje">
        <xsl:variable name="kdo" select="@who"/>
        <xsl:variable name="divID" select="@divId"/>
        <xsl:apply-templates mode="govori-var5-ciscenje2">
            <xsl:with-param name="kdo" select="$kdo"/>
            <xsl:with-param name="divID" select="$divID"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="tei:u" mode="govori-var5-ciscenje2">
        <xsl:param name="kdo"/>
        <xsl:param name="divID"/>
        <u who="{$kdo}" divId="{$divID}">
            <xsl:value-of select="normalize-space(.)"/>
        </u>
    </xsl:template>
    
    <xsl:template match="tei:stage" mode="govori-var5-ciscenje2">
        <xsl:param name="divID"/>
        <u who="{concat('#',$idKomentatorja)}" divId="{$divID}">
            <xsl:value-of select="normalize-space(.)"/>
        </u>
    </xsl:template>
    
    <xsl:template match="node()|@*" mode="govori-var6-doda_id">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" mode="govori-var6-doda_id"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:div" mode="govori-var6-doda_id">
        <xsl:variable name="divPosition" select="position()"/>
        <div xml:id="{concat('div-',$divPosition)}">
            <xsl:for-each select="tei:u[string-length(.) gt 0] | tei:anchor">
                <xsl:choose>
                    <xsl:when test="xs:string(node-name(.)) eq 'u'">
                        <u xml:id="{concat('u-',$divPosition,'.',position())}" who="{@who}">
                            <!-- atr divId začasno shranim v atr ana (uvodne komentatorjeve besede (docDate ipd.) nimajo tega atributa, zato preferem if) -->
                            <xsl:if test="@divId">
                                <xsl:attribute name="ana">
                                    <xsl:value-of select="@divId"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="normalize-space(.)"/>
                        </u>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- kopira anchor -->
                        <xsl:copy-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </div>
    </xsl:template>
    
    <xsl:template match="node()|@*" mode="govori-var-8-datum">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" mode="govori-var-8-datum"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:u" mode="govori-var-8-datum">
        <u n="{preceding::tei:anchor[@n][1]/@n}">
            <xsl:apply-templates select="@*" mode="govori-var-8-datum"/>
            <xsl:value-of select="normalize-space(.)"/>
        </u>
    </xsl:template>
    
    <xsl:template match="node()|@*" mode="govori-var-8b-premakni_anchor">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" mode="govori-var-8b-premakni_anchor"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:div" mode="govori-var-8b-premakni_anchor">
        <xsl:variable name="datum" select="tei:u[1]/@n"/>
        <div xml:id="{@xml:id}">
            <!-- Po pravilu si znotraj div sledita dva datumska anchor: prvi označuje konec obdobja,
                drugi začetek naslednjega obdobja. Samo začetek in konec celotne seje ima eden anchor (Pozor: datumi lahko manjkajo, ker
                v viru ni bilo tega podatka; proti temu ne moremo nič ...). Začetek obdobja premaknemo v naslednji div. -->
            <xsl:if test="preceding-sibling::tei:div[1][tei:anchor/@n = $datum] and preceding-sibling::tei:div[1]/tei:anchor[2][@n = $datum]">
                <xsl:copy-of select="preceding-sibling::tei:div[1]/tei:anchor[@n = $datum]"/>
            </xsl:if>
            <xsl:apply-templates mode="govori-var-8b-premakni_anchor"/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:anchor[@n]" mode="govori-var-8b-premakni_anchor">
        <xsl:choose>
            <xsl:when test="parent::tei:div/tei:anchor[2][@n]">
                <!-- ga izbrišem -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="node()|@*" mode="govori-var-11-ciscenje">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" mode="govori-var-11-ciscenje"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:u" mode="govori-var-11-ciscenje">
        <u xml:id="{@xml:id}" who="{@who}">
            <xsl:value-of select="normalize-space(.)"/>
        </u>
    </xsl:template>
    
    <xsl:template match="tei:anchor" mode="govori-var-11-ciscenje">
        <anchor xml:id="{@xml:id}"/>
    </xsl:template>
    
</xsl:stylesheet>