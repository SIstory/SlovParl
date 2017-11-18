<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <!-- izhodiščni dokument je izbrani teiCorpus iz direktorija SlovParl/teiCorpus  -->
    
    <xsl:output method="xml" indent="yes"/>
    
    <!-- vstavi pot do izhodiščnega direktorija, v katerem boš kreiral child direktorije in shranil result-document -->
    <xsl:param name="path2folder">/Users/administrator/Documents/moje/clarin/SlovParl/</xsl:param>
    
    <!-- vstavi xpath do toc dokumenta za kazalo vsebine (celoten korpus) -->
    <xsl:param name="toc-document">../toc/Sk-11.xml</xsl:param>
    <!-- vstavi povezavo do TEI dokumenta s seznamom govornikoc -->
    <xsl:param name="speaker-document">../speaker.xml</xsl:param>
    
    <xsl:param name="idCommentator">commentator</xsl:param>
    
    <xsl:param name="editionStmt">
        <editionStmt>
            <edition>1.0</edition>
        </editionStmt>
    </xsl:param>
    <xsl:param name="publisher">
        <publisher>
            <orgName xml:lang="sl">Inštitut za novejšo zgodovino</orgName>
            <orgName xml:lang="en">Institute of Contemporary History</orgName>
            <ref target="http://www.inz.si/">http://www.inz.si/</ref>
            <address>
                <street>Kongresni trg 1</street>
                <settlement>Ljubljana</settlement>
                <postCode>1000</postCode>
                <country xml:lang="sl">Slovenija</country>
                <country xml:lang="en">Slovenia</country>
            </address>
            <email>inz@inz.si</email>
        </publisher>
    </xsl:param>
    <xsl:param name="distributor">
        <distributor>DARIAH-SI</distributor>
        <distributor>CLARIN.SI</distributor>
    </xsl:param>
    <xsl:param name="pubPlace">
        <pubPlace>https://github.com/DARIAH-SI/CLARIN.SI/tree/master/SlovParl/</pubPlace>
    </xsl:param>
    <xsl:param name="licence">
        <availability status="free">
            <licence>http://creativecommons.org/licenses/by/4.0/</licence>
            <p xml:lang="en">This work is licensed under the <ref
                target="http://creativecommons.org/licenses/by/4.0/">Creative Commons
                Attribution 4.0 International License</ref>.</p>
            <p xml:lang="sl">To delo je ponujeno pod <ref
                target="http://creativecommons.org/licenses/by/4.0/">Creative Commons
                Priznanje avtorstva 4.0 mednarodna licenca</ref>.</p>
        </availability>
    </xsl:param>
    <xsl:param name="projectDesc">
        <projectDesc>
            <p xml:lang="sl">Infrastrukturni program Raziskovalna infrastruktura slovenskega zgodovinopisja</p>
            <p xml:lang="en">Infrastructure Programme Research infrastructure of Slovenian Historiography</p>
        </projectDesc>
    </xsl:param>
    <!-- generični respStmt za vse TEI dokumente -->
    <xsl:param name="respStmt">
        <respStmt>
            <persName>Andrej Pančur</persName>
            <resp xml:lang="sl">Kodiranje TEI</resp>
            <resp xml:lang="en">TEI corpus encoding</resp>
        </respStmt>
        <respStmt>
            <persName>Mojca Šorn</persName>
            <resp xml:lang="sl">Kodiranje TEI</resp>
            <resp xml:lang="en">TEI corpus encoding</resp>
        </respStmt>
    </xsl:param>
    <!-- generični funder za vse TEI dokumente -->
    <xsl:param name="funder">
        <funder>
            <orgName xml:lang="sl">Javna agencija za raziskovalno dejavnost Republike Slovenije</orgName>
            <orgName xml:lang="en">Slovenian Research Agency</orgName>
        </funder>
    </xsl:param>
    
    <!-- seznam virov za narejeno taxonomy in toc -->
    <xsl:param name="listBibl">
        <listBibl>
            <bibl>
                <title>Pravni red Republike Slovenije</title>
                <title>Tematsko kazalo</title>
                <ref target="http://www.pisrs.si/Pis.web/pravniRedRSDrzavniNivoKazalaTematskoKazalo">Pravni red Republike Slovenije</ref>
            </bibl>
            <biblStruct>
                <analytic>
                    <title>Poslovnik državnega zbora (PoDZ-1)</title>
                </analytic>
                <monogr>
                    <title>Uradni list Republike Slovenije</title>
                    <imprint>
                        <biblScope unit="issue">7</biblScope>
                        <date>2007</date>
                    </imprint>
                </monogr>
                <ref target="http://www.pisrs.si/Pis.web/pregledPredpisa?id=POSL34">http://www.pisrs.si/Pis.web/pregledPredpisa?id=POSL34</ref>
            </biblStruct>
        </listBibl>
    </xsl:param>
    
    <xsl:variable name="document-uri" select="document-uri(.)"/>
    <xsl:variable name="filename" select="(tokenize($document-uri,'/'))[last()]"/>
    
    <xsl:variable name="mandates">
        <!--<mandate from="" to="">Sk-01</mandate>
        <mandate from="" to="">Sk-02</mandate>
        <mandate from="" to="">Sk-03</mandate>
        <mandate from="" to="">Sk-04</mandate>
        <mandate from="" to="">Sk-05</mandate>
        <mandate from="" to="">Sk-06</mandate>
        <mandate from="" to="">Sk-07</mandate>
        <mandate from="" to="">Sk-08</mandate>
        <mandate from="" to="">Sk-09</mandate>
        <mandate from="" to="" name="Skupščina Socialistične republike Slovenije">Sk-10</mandate>-->
        <mandate from="1990-05-07" to="1992-12-22" name="Skupščina Republike Slovenije" nameEn="Assembly of the Republic of Slovenia">Sk-11</mandate>
        <mandate from="1992-12-23" to="1996-11-27" name="Državni zbor Republike Slovenije" nameEn="National Assembly of the Republic of Slovenia">DZ-01</mandate>
        <mandate from="1996-11-28" to="2000-10-26" name="Državni zbor Republike Slovenije" nameEn="National Assembly of the Republic of Slovenia">DZ-02</mandate>
        <mandate from="2000-10-27" to="2004-10-21" name="Državni zbor Republike Slovenije" nameEn="National Assembly of the Republic of Slovenia">DZ-03</mandate>
        <mandate from="2004-10-22" to="2008-10-14" name="Državni zbor Republike Slovenije" nameEn="National Assembly of the Republic of Slovenia">DZ-04</mandate>
        <mandate from="2008-10-15" to="2011-12-15" name="Državni zbor Republike Slovenije" nameEn="National Assembly of the Republic of Slovenia">DZ-05</mandate>
        <mandate from="2011-12-16" to="2014-07-31" name="Državni zbor Republike Slovenije" nameEn="National Assembly of the Republic of Slovenia">DZ-06</mandate>
    </xsl:variable>
    
    <!-- povezava na avtorje skupnih kazal vsebine -->
    <xsl:variable name="link-to-toc-author">
        <xsl:for-each select="document($toc-document)/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author">
            <xsl:value-of select="concat('#toc.',translate(.,' ',''))"/>
            <xsl:if test="position() != last()">
                <xsl:text> </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
    
    <!-- iz skupnega kazala naredim začasno taxonomy (v @ana povezave na ustrezne div) 
                 in jo shrabim v variablo za kasnejšo obdelavo -->
    <xsl:variable name="taxonomy-toc">
        <xsl:for-each select="document($toc-document)//tei:text/tei:body">
            <category xml:id="taxonomy.root">
                <xsl:call-template name="taxonomy-toc-ana-attribute"/>
                <xsl:for-each select="tei:head">
                    <catDesc xml:lang="{@xml:lang}">
                        <xsl:value-of select="."/>
                    </catDesc>
                </xsl:for-each>
                <xsl:call-template name="taxonomy-toc-topic"/>
                <xsl:call-template name="taxonomy-toc-category"/>
            </category>
        </xsl:for-each>
    </xsl:variable>
    <!-- shranim podatke v bolj dostopno variablo -->
    <xsl:variable name="taxonomy-toc-2">
        <xsl:for-each select="$taxonomy-toc//tei:category">
            <xsl:variable name="id" select="@xml:id"/>
            <xsl:for-each select="tokenize(@ana,' ')">
                <category xml:id="{$id}">
                    <xsl:value-of select="substring-after(.,'corp:')"/>
                </category>
            </xsl:for-each>
        </xsl:for-each>
        <xsl:for-each select="$taxonomy-toc//tei:title[@type='topic']">
            <xsl:variable name="id" select="@xml:id"/>
            <xsl:for-each select="tokenize(@ana,' ')">
                <category xml:id="{$id}">
                    <xsl:value-of select="substring-after(.,'corp:')"/>
                </category>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:variable>
    
    <!-- iz prvotne taxonomy naredim variablo za kasnejšo obdelavo:  -->
    <xsl:variable name="taxonomy-parliament">
        <xsl:for-each select="tei:teiCorpus/tei:teiHeader/tei:encodingDesc/tei:classDecl/tei:taxonomy//tei:category">
            <xsl:variable name="categoryName" select="substring-after(@xml:id,'PAR.')"/>
            <xsl:for-each select="tei:catDesc">
                <category name="{$categoryName}">
                    <xsl:if test="@xml:lang">
                        <xsl:attribute name="xml:lang">
                            <xsl:value-of select="@xml:lang"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="."/>
                </category>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:template match="tei:teiCorpus">
        <xsl:variable name="document-corpus" select="concat($path2folder,'SlovParl.xml')"/>
        <xsl:result-document href="{$document-corpus}" >
            <teiCorpus xmlns:xi="http://www.w3.org/2001/XInclude">
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <xsl:for-each select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title">
                                <xsl:copy-of select="."/>
                            </xsl:for-each>
                            <xsl:for-each select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt">
                                <xsl:copy-of select="."/>
                            </xsl:for-each>
                            <!-- dodam avtorje celotnega kazala -->
                            <xsl:for-each select="document($toc-document)/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author">
                                <respStmt xml:id="{concat('toc.',translate(.,' ',''))}">
                                    <persName>
                                        <xsl:value-of select="."/>
                                    </persName>
                                    <resp xml:lang="sl">Ustvarjalec tematskega kazala vsebine</resp>
                                    <resp xml:lang="en">Creator of the thematic table of contents</resp>
                                </respStmt>
                            </xsl:for-each>
                            <xsl:for-each select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:funder">
                                <xsl:copy-of select="."/>
                            </xsl:for-each>
                        </titleStmt>
                        <xsl:copy-of select="$editionStmt"/>
                        <publicationStmt>
                            <xsl:copy-of select="$publisher"/>
                            <xsl:copy-of select="$distributor"/>
                            <xsl:copy-of select="$pubPlace"/>
                            <xsl:copy-of select="$licence"/>
                            <date when="{current-date()}"/>
                        </publicationStmt>
                        <sourceDesc>
                            <biblFull>
                                <xsl:copy-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt"/>
                                <xsl:copy-of select="tei:teiHeader/tei:fileDesc/tei:publicationStmt"/>
                            </biblFull>
                        </sourceDesc>
                    </fileDesc>
                    <encodingDesc>
                        <xsl:copy-of select="$projectDesc"/>
                        <classDecl>
                            <taxonomy xml:id="contents">
                                <xsl:copy-of select="$listBibl"/>
                                <!-- iz variable taxonomy odstranim @ana in taksonomijo izpišem -->
                                <xsl:variable name="taxonomy-3">
                                    <xsl:apply-templates select="$taxonomy-toc" mode="taxonomy-remove_ana"/>
                                </xsl:variable>
                                <xsl:copy-of select="$taxonomy-3"/>
                            </taxonomy>
                        </classDecl>
                    </encodingDesc>
                    <profileDesc>
                        <particDesc>
                            <xsl:variable name="speakers">
                                <xsl:for-each select="distinct-values(//tei:sp/substring-after(@who,'sp:'))">
                                    <speaker>
                                        <xsl:value-of select="."/>
                                    </speaker>
                                </xsl:for-each>
                            </xsl:variable>
                            <!-- dodam še komentatorja -->
                            <listPerson>
                                <person xml:id="{$idCommentator}">
                                    <state>
                                        <label xml:lang="sl">komentator</label>
                                        <label xml:lang="en">commentator</label>
                                    </state>
                                </person>
                            </listPerson>
                            <xsl:for-each select="document($speaker-document)//tei:listPerson">
                                <listPerson>
                                    <xsl:for-each select="tei:head">
                                        <xsl:copy-of select="."/>
                                    </xsl:for-each>
                                    <xsl:for-each select="tei:personGrp">
                                        <xsl:copy-of select="."/>
                                    </xsl:for-each>
                                    <xsl:for-each select="tei:person[@xml:id = $speakers/tei:speaker]">
                                        <xsl:copy-of select="."/>
                                    </xsl:for-each>
                                </listPerson>
                            </xsl:for-each>
                            <xsl:for-each select="document($speaker-document)//tei:profileDesc/tei:particDesc/tei:listOrg">
                                <xsl:copy-of select="."/>
                            </xsl:for-each>
                        </particDesc>
                        <!-- če obstaja, kopiraj langUsage -->
                        <xsl:copy-of select="tei:teiHeader/tei:profileDesc/tei:langUsage"/>
                        <!-- če obstaja, kopiraj settingDesc -->
                        <xsl:copy-of select="tei:teiHeader/tei:profileDesc/tei:settingDesc"/>
                    </profileDesc>
                </teiHeader>
                
                <!-- začetek procesiranja posameznih TEI dokumentov, v okviru katere dodam tudi xi:include na te dokumente -->
                <xsl:for-each select="tei:TEI/tei:text/tei:body/tei:div/tei:div">
                    <xsl:variable name="docDate-first" select="tei:docDate/tei:date[1]/@when"/>
                    <xsl:variable name="folder-mandate">
                        <xsl:for-each select="$mandates/tei:mandate">
                            <xsl:if test="xs:date(@from) eq xs:date($docDate-first) or xs:date(@from) lt xs:date($docDate-first)">
                                <xsl:if test="xs:date(@to) eq xs:date($docDate-first) or xs:date(@to) gt xs:date($docDate-first)">
                                    <xsl:value-of select="."/>
                                </xsl:if>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="chamber" select="tokenize(substring-after(parent::tei:div/@ana,'#PAR.'),' ')[1]"/>
                    <xsl:variable name="session-type-category" select="substring-after(@ana,'#PAR.')"/>
                    <!-- Če je Seja, dobi črko s, če pa je zasedanje, dobi črko z -->
                    <xsl:variable name="session-type">
                        <xsl:choose>
                            <xsl:when test="$session-type-category = 'Seja'">s</xsl:when>
                            <xsl:when test="$session-type-category = 'Zasedanje'">z</xsl:when>
                            <xsl:when test="$session-type-category = 'Delovna'">d</xsl:when>
                            <xsl:when test="$session-type-category = 'Slavnostna'">sl</xsl:when>
                            <xsl:otherwise>
                                <xsl:message terminate="yes">Manjka session-type vrednost</xsl:message>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="session-number">
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
                    <xsl:variable name="president">
                        <xsl:for-each select="tei:castList/tei:castItem/tei:actor">
                            <xsl:variable name="actorId" select="@xml:id"/>
                            <president>
                                <xsl:value-of select="distinct-values(//tei:sp[substring-after(@corresp,'#') = $actorId]/substring-after(@who,'sp:'))"/>
                            </president>
                        </xsl:for-each>
                    </xsl:variable>
                    
                    <!-- govore sp odstranim iz div hierarhije in njihovim p, speaker, ad in stage dodam atribute who (iz sp) in div-id (iz parent div/@xml:id) -->
                    <xsl:variable name="govori-var1">
                        <xsl:apply-templates select="tei:div/tei:div" mode="govori-1"/>
                    </xsl:variable>
                    <!-- sp, ki so bili prej ločeni zaradi vsebinskih div, združim glede na govorca -->
                    <xsl:variable name="govori-var2">
                        <xsl:for-each-group select="$govori-var1/*" group-starting-with="tei:sp[tei:speaker]">
                            <!-- dodan tip za div (govori iz govorniških klopi (podium) - sp (speech) ali
                                zapisani govori, ki so prekinili glavne govore - inter (interruption) -->
                            <div type="{current-group()[@divType][1]/@divType}">
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
                            <div type="preface">
                                <anchor xml:id="{tei:stage/tei:time[@from]/@xml:id}" n="{tokenize(tei:stage/tei:time/@from,'T')[1]}"/>
                                <u who="{concat('#',$idCommentator)}" type="head"><xsl:value-of select="normalize-space(../tei:head)"/></u>
                                <u who="{concat('#',$idCommentator)}" type="head"><xsl:value-of select="normalize-space(tei:head)"/></u>
                                <u who="{concat('#',$idCommentator)}" type="date"><xsl:value-of select="normalize-space(tei:docDate)"/></u>
                                <u who="{concat('#',$idCommentator)}" type="president"><xsl:value-of select="normalize-space(tei:castList)"/></u>
                                <u who="{concat('#',$idCommentator)}" type="time"><xsl:value-of select="normalize-space(tei:stage)"/></u>
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
                    <!-- div[@type='inter'] razdelim (glede na različna govornika) na pravi interruption govor 
                        in na glavni govor, ki se je nadaljeval po tej prekinitvi) -->
                    <xsl:variable name="govori-var5b">
                        <xsl:apply-templates select="$govori-var5" mode="govori-var5b-razcepi_inter_div">
                            <xsl:with-param name="idCommentator" select="$idCommentator"/>
                        </xsl:apply-templates>
                    </xsl:variable>
                    <!-- dodani xml:id vsem elementom v variabli (glede na position() ) -->
                    <xsl:variable name="govori-var6">
                        <xsl:apply-templates select="$govori-var5b" mode="govori-var6-doda_id"/>
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
                        <xsl:variable name="position" select="position()"/>
                        <xsl:variable name="dategroup-number" >
                            <xsl:choose>
                                <xsl:when test="$position lt 10">
                                    <xsl:value-of select="concat('0',$position)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$position"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <!-- vsebino shranim v variablo (jo uporabim za konstrukcijo kazala in timeline -->
                        <xsl:variable name="govori-var10">
                            <xsl:for-each select="current-group()">
                                <xsl:copy-of select="."/>
                            </xsl:for-each>
                        </xsl:variable>
                        <!-- dodam ana atribut s povezavo na taxonomy -->
                        <xsl:variable name="govori-var10a">
                            <xsl:for-each select="$govori-var10/tei:div">
                                <div xml:id="{@xml:id}">
                                    <xsl:if test="@type">
                                        <xsl:attribute name="type">
                                            <xsl:value-of select="@type"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:for-each select="node()">
                                        <xsl:choose>
                                            <xsl:when test="name(.) = 'u'">
                                                <xsl:variable name="corresp" select="@corresp"/>
                                                <u n="{@n}" xml:id="{@xml:id}" who="{@who}">
                                                    <xsl:if test="@corresp">
                                                        <xsl:attribute name="corresp">
                                                            <xsl:value-of select="@corresp"/>
                                                        </xsl:attribute>
                                                        <xsl:attribute name="ana">
                                                            <xsl:for-each select="$taxonomy-toc-2//tei:category[. = $corresp]">
                                                                <xsl:value-of select="concat('#',@xml:id)"/>
                                                                <!-- je lahko vezan na več kot eno kategorijo -->
                                                                <xsl:if test="position() != last()">
                                                                    <xsl:text> </xsl:text>
                                                                </xsl:if>
                                                            </xsl:for-each>
                                                        </xsl:attribute>
                                                    </xsl:if>
                                                    <xsl:call-template name="stage-type-attribute"/>
                                                    <xsl:value-of select="."/>
                                                </u>
                                            </xsl:when>
                                            <!-- drugače je anchor, ki ga samo kopiramo -->
                                            <xsl:otherwise>
                                                <xsl:copy-of select="."/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each>
                                </div>
                            </xsl:for-each>
                        </xsl:variable>
                        <!-- Pred koncem počistim odvečne corresp in n atribute iz elementov u in anchor; -->
                        <xsl:variable name="govori-var11">
                            <xsl:apply-templates select="$govori-var10a" mode="govori-var-11-ciscenje"/>
                        </xsl:variable>
                        
                        <!-- Na koncu naredim iz vseh xml:id unikatne identifikatorje (dodam uniqueId TEI dokumenta) -->
                        <!-- u/@type spremenim v adekvatne note in incident elemente -->
                        <xsl:variable name="uniqueId" select="concat($chamber,'.',current-grouping-key(),'.',$session-type,$session-number,'-',$dategroup-number)"/>
                        <xsl:variable name="govori-var12">
                            <xsl:for-each select="$govori-var11/tei:div">
                                <div>
                                    <xsl:if test="@type">
                                        <xsl:attribute name="type">
                                            <xsl:value-of select="@type"/>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:for-each select="node()">
                                        <xsl:choose>
                                            <xsl:when test="xs:string(node-name(.)) = 'u'">
                                                <!-- glede na morebitni type atribut iz u naredim nove elemente note, incident itd. -->
                                                <xsl:choose>
                                                    <xsl:when test=".[@type='incident']">
                                                        <incident xml:id="{concat($uniqueId,'.',@xml:id)}" who="{@who}">
                                                            <xsl:call-template name="ana-attribute"/>
                                                            <desc>
                                                                <xsl:call-template name="remove-parenthesis"/>
                                                            </desc>
                                                        </incident>
                                                    </xsl:when>
                                                    <xsl:when test=".[@type='kinesic']">
                                                        <kinesic xml:id="{concat($uniqueId,'.',@xml:id)}" who="{@who}">
                                                            <xsl:call-template name="ana-attribute"/>
                                                            <desc>
                                                                <xsl:call-template name="remove-parenthesis"/>
                                                            </desc>
                                                        </kinesic>
                                                    </xsl:when>
                                                    <xsl:when test=".[@type='vocal']">
                                                        <vocal xml:id="{concat($uniqueId,'.',@xml:id)}" who="{@who}">
                                                            <xsl:call-template name="ana-attribute"/>
                                                            <desc>
                                                                <xsl:call-template name="remove-parenthesis"/>
                                                            </desc>
                                                        </vocal>
                                                    </xsl:when>
                                                    <xsl:when test=".[@type='writing']">
                                                        <writing xml:id="{concat($uniqueId,'.',@xml:id)}" who="{@who}">
                                                            <xsl:call-template name="ana-attribute"/>
                                                            <desc>
                                                                <xsl:call-template name="remove-parenthesis"/>
                                                            </desc>
                                                        </writing>
                                                    </xsl:when>
                                                    <xsl:when test=".[@type='gap']">
                                                        <gap xml:id="{concat($uniqueId,'.',@xml:id)}" reason="inaudible">
                                                            <xsl:call-template name="ana-attribute"/>
                                                            <desc>
                                                                <xsl:call-template name="remove-parenthesis"/>
                                                            </desc>
                                                        </gap>
                                                    </xsl:when>
                                                    <xsl:when test=".[@type='head']">
                                                        <head xml:id="{concat($uniqueId,'.',@xml:id)}">
                                                            <xsl:value-of select="."/>
                                                        </head>
                                                    </xsl:when>
                                                    <xsl:when test=".[@type='date']">
                                                        <xsl:call-template name="note">
                                                            <xsl:with-param name="uniqueId" select="$uniqueId"/>
                                                        </xsl:call-template>
                                                    </xsl:when>
                                                    <xsl:when test=".[@type='president']">
                                                        <xsl:call-template name="note">
                                                            <xsl:with-param name="uniqueId" select="$uniqueId"/>
                                                        </xsl:call-template>
                                                    </xsl:when>
                                                    <xsl:when test=".[@type='location']">
                                                        <xsl:call-template name="note">
                                                            <xsl:with-param name="uniqueId" select="$uniqueId"/>
                                                        </xsl:call-template>
                                                    </xsl:when>
                                                    <xsl:when test=".[@type='speaker']">
                                                        <xsl:call-template name="note">
                                                            <xsl:with-param name="uniqueId" select="$uniqueId"/>
                                                        </xsl:call-template>
                                                    </xsl:when>
                                                    <xsl:when test=".[@type='comment']">
                                                        <xsl:call-template name="note">
                                                            <xsl:with-param name="uniqueId" select="$uniqueId"/>
                                                        </xsl:call-template>
                                                    </xsl:when>
                                                    <xsl:when test=".[@type='time']">
                                                        <xsl:call-template name="note">
                                                            <xsl:with-param name="uniqueId" select="$uniqueId"/>
                                                        </xsl:call-template>
                                                    </xsl:when>
                                                    <xsl:when test=".[@type='quorum']">
                                                        <xsl:call-template name="note">
                                                            <xsl:with-param name="uniqueId" select="$uniqueId"/>
                                                        </xsl:call-template>
                                                    </xsl:when>
                                                    <xsl:when test=".[@type='vote']">
                                                        <xsl:call-template name="note">
                                                            <xsl:with-param name="uniqueId" select="$uniqueId"/>
                                                        </xsl:call-template>
                                                    </xsl:when>
                                                    <xsl:when test=".[@type='debate']">
                                                        <xsl:call-template name="note">
                                                            <xsl:with-param name="uniqueId" select="$uniqueId"/>
                                                        </xsl:call-template>
                                                    </xsl:when>
                                                    <!-- drugače je govor u -->
                                                    <xsl:otherwise>
                                                        <u xml:id="{concat($uniqueId,'.',@xml:id)}" who="{@who}">
                                                            <xsl:call-template name="ana-attribute"/>
                                                            <!-- če bo dodalo type atribut, kateri ni bil procesiran z when,
                                                                bo shema javila napako, saj u ne sme imeti type atributa -->
                                                            <xsl:call-template name="stage-type-attribute"/>
                                                            <xsl:value-of select="."/>
                                                        </u>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:when>
                                            <!-- drugače je anchor, ki ga samo kopiramo -->
                                            <xsl:otherwise>
                                                <xsl:copy-of select="."/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each>
                                </div>  <!-- odstranil div -->
                            </xsl:for-each>
                        </xsl:variable>
                        
                        <!-- preden naredim TEI dokumente, najprej naredim xi:include iz teiCorpus na vse te dokumente -->
                        <xsl:text disable-output-escaping="yes"><![CDATA[<xi:include href="]]></xsl:text>
                        <xsl:value-of select="concat($folder-mandate,'/',current-grouping-key(),'-',$chamber,'-',$session-type,$session-number,'-',$dategroup-number,'.xml')"/>
                        <xsl:text disable-output-escaping="yes"><![CDATA["/>]]></xsl:text>
                        
                        <!-- ustvarim TEI dokument -->
                        <xsl:variable name="document" select="concat($path2folder,$folder-mandate,'/',current-grouping-key(),'-',$chamber,'-',$session-type,$session-number,'-',$dategroup-number,'.xml')"/>
                        <xsl:result-document href="{$document}" exclude-result-prefixes="xi">
                            <TEI xml:id="{$uniqueId}" xml:lang="sl">
                                <teiHeader>
                                    <fileDesc>
                                        <titleStmt>
                                            <title xml:lang="sl">Zapisniki sej</title>
                                            <title xml:lang="en">Stenographic minutes</title>
                                            <xsl:for-each select="$mandates/tei:mandate[. = $folder-mandate]">
                                                <title xml:lang="sl">
                                                    <xsl:value-of select="@name"/>
                                                </title>
                                                <title xml:lang="en">
                                                    <xsl:value-of select="@nameEn"/>
                                                </title>
                                            </xsl:for-each>
                                            <xsl:for-each select="$taxonomy-parliament/tei:category[@name = $chamber]">
                                                <title>
                                                    <xsl:if test="@xml:lang">
                                                        <xsl:attribute name="xml:lang">
                                                            <xsl:value-of select="@xml:lang"/>
                                                        </xsl:attribute>
                                                    </xsl:if>
                                                    <xsl:value-of select="."/>
                                                </title>
                                            </xsl:for-each>
                                            <xsl:choose>
                                                <xsl:when test="$session-type = 's'">
                                                    <title xml:lang="sl">Seja <xsl:value-of select="number($session-number)"/></title>
                                                    <title xml:lang="en">Session <xsl:value-of select="number($session-number)"/></title>
                                                </xsl:when>
                                                <xsl:when test="$session-type = 'd'">
                                                    <title xml:lang="sl">Delovna seja <xsl:value-of select="number($session-number)"/></title>
                                                    <title xml:lang="en">Working session <xsl:value-of select="number($session-number)"/></title>
                                                </xsl:when>
                                                <xsl:when test="$session-type = 'sl'">
                                                    <title xml:lang="sl">Slavnostna seja <xsl:value-of select="number($session-number)"/></title>
                                                </xsl:when>
                                                <xsl:when test="$session-type = 'z'">
                                                    <title xml:lang="sl">Zasedanje <xsl:value-of select="number($session-number)"/></title>
                                                    <title xml:lang="en">Session <xsl:value-of select="number($session-number)"/></title>
                                                </xsl:when>
                                            </xsl:choose>
                                            <xsl:copy-of select="$respStmt"/>
                                            <xsl:copy-of select="$funder"/>
                                        </titleStmt>
                                        <publicationStmt>
                                            <xsl:copy-of select="$publisher"/>
                                            <xsl:copy-of select="$distributor"/>
                                            <xsl:copy-of select="$pubPlace"/>
                                            <xsl:copy-of select="$licence"/>
                                            <date when="{current-date()}"/>
                                        </publicationStmt>
                                        <sourceDesc>
                                            <bibl><xsl:value-of select="$filename"/></bibl>
                                        </sourceDesc>
                                    </fileDesc>
                                    <encodingDesc>
                                        <xsl:copy-of select="$projectDesc"/>
                                    </encodingDesc>
                                    <profileDesc>
                                        <particDesc>
                                            <!-- vstavim povezave na govorove predsednika in podpredsednika posameznega zbora -->
                                            <listPerson>
                                                <head xml:lang="sl">Predsedujoči zasedanja</head>
                                                <head xml:lang="en">Chairman of a meeting</head>
                                                <xsl:for-each select="$president/tei:president">
                                                    <xsl:variable name="presidentId" select="."/>
                                                    <xsl:if test="$govori-var10/tei:div/tei:u[substring-after(@who,'#') = $presidentId]">
                                                        <person role="president" sameAs="{concat('#',.)}">
                                                            <xsl:attribute name="corresp">
                                                                <xsl:for-each select="$govori-var10//tei:u[substring-after(@who,'#') = $presidentId]">
                                                                    <xsl:value-of select="concat('#',$uniqueId,'.',@xml:id)"/>
                                                                    <xsl:if test="position() != last()">
                                                                        <xsl:text> </xsl:text>
                                                                    </xsl:if>
                                                                </xsl:for-each>
                                                            </xsl:attribute>
                                                        </person>
                                                    </xsl:if>
                                                </xsl:for-each>
                                            </listPerson>
                                        </particDesc>
                                        <settingDesc>
                                            <setting>
                                                <date when="{current-grouping-key()}"/>
                                            </setting>
                                        </settingDesc>
                                    </profileDesc>
                                </teiHeader>
                                <text xml:lang="sl">
                                    <front>
                                        <div type="contents">
                                            <list>
                                                <xsl:for-each-group select="$govori-var10//tei:u" group-by="@corresp">
                                                    <item xml:id="{concat($uniqueId,'.toc-item',position())}">
                                                        <xsl:attribute name="corresp">
                                                            <xsl:for-each select="current-group()">
                                                                <xsl:value-of select="concat('#',$uniqueId,'.',@xml:id)"/>
                                                                <xsl:if test="position() != last()">
                                                                    <xsl:text> </xsl:text>
                                                                </xsl:if>
                                                            </xsl:for-each>
                                                        </xsl:attribute>
                                                        <xsl:variable name="naslov-kazalo">
                                                            <xsl:for-each select="document($toc-document)//tei:item[substring-after(@corresp,'corp:') = current-grouping-key()]">
                                                                <title>
                                                                    <xsl:value-of select="normalize-space(tei:p)"/>
                                                                </title>
                                                            </xsl:for-each>
                                                        </xsl:variable>
                                                        <!-- v kazalu celotnega korpusa se lahko isti item/@cooresp nahajajo v razližnih vsebinskih sklopih
                                                             (imajo atribut synche, ki jih povezuje med seboj preko xml:id) -->
                                                        <title>
                                                            <xsl:value-of select="$naslov-kazalo/tei:title[1]"/>
                                                        </title>
                                                    </item>
                                                </xsl:for-each-group>
                                            </list>
                                        </div>
                                    </front>
                                    <body>
                                        <!-- prečiščim originalni timeline glede na isti datum -->
                                        <xsl:variable name="timeline-when">
                                            <xsl:for-each select="$timeline//tei:when[tokenize(@absolute,'T')[1] = current-grouping-key()]">
                                                <xsl:copy-of select="."/>
                                            </xsl:for-each>
                                        </xsl:variable>
                                        <timeline origin="{$timeline-when/tei:when[1]/concat('#',@xml:id)}" unit="s">
                                            <xsl:for-each select="$timeline-when//tei:when">
                                                <xsl:copy-of select="."/>
                                            </xsl:for-each>
                                        </timeline>
                                        <!-- kopiram vsebino govorov iz zadnje govor variable -->
                                        <xsl:copy-of select="$govori-var12"/>
                                    </body>
                                </text>
                            </TEI>
                        </xsl:result-document>
                    </xsl:for-each-group>
                </xsl:for-each>
            </teiCorpus>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="tei:sp" mode="govori-1">
        <xsl:variable name="sp-who" select="substring-after(@who,'sp:')"/>
        <xsl:variable name="div-id" select="parent::tei:div/@xml:id"/>
        <xsl:variable name="div-type">
            <!-- določim tip govora (iz govorniškega odra ali iz klopi) -->
            <xsl:choose>
                <xsl:when test="tei:ab">inter</xsl:when>
                <xsl:otherwise>sp</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <sp divType="{$div-type}">
            <xsl:apply-templates mode="govori-2">
                <xsl:with-param name="sp-who" select="$sp-who"/>
                <xsl:with-param name="div-id" select="$div-id"/>
            </xsl:apply-templates>
        </sp>
    </xsl:template>
    
    <!-- procesira div/stage -->
    <xsl:template match="tei:stage" mode="govori-1">
        <xsl:variable name="sp-who" select="substring-after(@who,'sp:')"/>
        <xsl:variable name="div-id" select="parent::tei:div/@xml:id"/>
        <xsl:choose>
            <xsl:when test=".[@type = 'time']">
                <p who="{concat('#',$idCommentator)}" divId="{$div-id}">
                    <xsl:call-template name="stage-type-attribute"/>
                    <xsl:value-of select="normalize-space(.)"/>
                </p>
                <xsl:if test="tei:time/@to">
                    <anchor xml:id="{tei:time[@to]/@xml:id}"/>
                </xsl:if>
                <xsl:if test="tei:time/@from">
                    <anchor xml:id="{tei:time[@from]/@xml:id}" n="{tokenize(tei:time/@from,'T')[1]}"/>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <p who="{concat('#',$idCommentator)}" divId="{$div-id}">
                    <xsl:call-template name="stage-type-attribute"/>
                    <xsl:value-of select="normalize-space(.)"/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:speaker" mode="govori-2">
        <xsl:param name="div-id"/>
        <speaker who="{concat('#',$idCommentator)}" divId="{$div-id}">
            <xsl:value-of select="normalize-space(.)"/>
        </speaker>
    </xsl:template>
    
    <!-- procesira sp/p -->
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
    
    <!-- procesira sp/ab -->
    <xsl:template match="tei:ab" mode="govori-2">
        <xsl:param name="sp-who"/>
        <xsl:param name="div-id"/>
        <p who="{concat('#',$sp-who)}" divId="{$div-id}">
            <xsl:call-template name="remove-parenthesis"/>
        </p>
    </xsl:template>
    
    <!-- procesira sp/stage -->
    <xsl:template match="tei:stage" mode="govori-2">
        <xsl:param name="div-id"/>
        <xsl:choose>
            <xsl:when test=".[@type = 'time']">
                <p who="{concat('#',$idCommentator)}" divId="{$div-id}">
                    <xsl:call-template name="stage-type-attribute"/>
                    <xsl:value-of select="normalize-space(.)"/>
                </p>
                <xsl:if test="tei:time/@to">
                    <anchor xml:id="{tei:time[@to]/@xml:id}"/>
                </xsl:if>
                <xsl:if test="tei:time/@from">
                    <anchor xml:id="{tei:time[@from]/@xml:id}" n="{tokenize(tei:time/@from,'T')[1]}"/>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <p who="{concat('#',$idCommentator)}" divId="{$div-id}">
                    <xsl:call-template name="stage-type-attribute"/>
                    <xsl:value-of select="normalize-space(.)"/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- procesira sp/p/stage -->
    <xsl:template match="tei:stage" mode="govori-3">
        <xsl:param name="div-id"/>
        <stage who="{concat('#',$idCommentator)}" divId="{$div-id}">
            <xsl:call-template name="stage-type-attribute"/>
            <xsl:value-of select="."/>
        </stage>
    </xsl:template>
    
    <xsl:template match="tei:div" mode="govori-var3-ciscenje">
        <div>
            <xsl:if test="@type">
                <xsl:attribute name="type">
                    <xsl:value-of select="@type"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="govori-var3-ciscenje"/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:sp" mode="govori-var3-ciscenje">
        <xsl:apply-templates mode="govori-var3-ciscenje"/>
    </xsl:template>
    
    <xsl:template match="tei:speaker" mode="govori-var3-ciscenje">
        <u who="{@who}" divId="{@divId}" type="speaker">
            <xsl:value-of select="normalize-space(.)"/>
        </u>
    </xsl:template>
    
    <xsl:template match="tei:anchor" mode="govori-var3-ciscenje">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    <xsl:template match="tei:p" mode="govori-var3-ciscenje">
        <u who="{@who}" divId="{@divId}">
            <xsl:call-template name="stage-type-attribute"/>
            <xsl:apply-templates mode="govori-var3-ciscenje2"/>
        </u>
    </xsl:template>
    
    <xsl:template match="tei:stage" mode="govori-var3-ciscenje2">
        <stage>
            <xsl:call-template name="stage-type-attribute"/>
            <xsl:value-of select="."/>
        </stage>
    </xsl:template>
    
    <!-- mode govori-var4-razdruzevanje:
         example at http://stackoverflow.com/questions/4215965/xslt-split-at-child-node 
         1. The use of the identity rule to copy every node as-is.
    -->
    <xsl:template match="node()|@*" mode="govori-var4-razdruzevanje">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" mode="govori-var4-razdruzevanje"/>
        </xsl:copy>
    </xsl:template>
    <!-- 2. The overriding of the identity rule with templates for processing only specific nodes -->
    <xsl:template match="/*" mode="govori-var4-razdruzevanje">
        <xsl:apply-templates mode="govori-var4-razdruzevanje"/>
    </xsl:template>
    <!-- 3. Using 1. and 2. above. -->
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
        <xsl:param name="kdo"/>
        <xsl:param name="divID"/>
        <u who="{concat('#',$idCommentator)}" divId="{$divID}">
            <xsl:call-template name="stage-type-attribute"/>
            <xsl:value-of select="normalize-space(.)"/>
        </u>
    </xsl:template>
    
    <xsl:template match="node()|@*" mode="govori-var5b-razcepi_inter_div">
        <xsl:param name="idCommentator"/>
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" mode="govori-var5b-razcepi_inter_div">
                <xsl:with-param name="idCommentator" select="$idCommentator"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:div[@type='inter']" mode="govori-var5b-razcepi_inter_div">
        <xsl:param name="idCommentator"/>
        <xsl:variable name="commentator" select="concat('#',$idCommentator)"/>
        <xsl:variable name="firstSpeaker" select="tei:u[@who][@who != $commentator][1]/@who"/>
        <xsl:variable name="secondSpeaker" select="tei:u[@who][@who != $commentator][@who != $firstSpeaker][1]/@who"/>
        <xsl:variable name="split">
            <split type="inter"/>
            <xsl:for-each select="node()">
                <xsl:choose>
                    <xsl:when test=".[@who = $secondSpeaker]">
                        <xsl:choose>
                            <xsl:when test="preceding-sibling::node()[@who = $secondSpeaker]"></xsl:when>
                            <!-- postavi split element samo pred element, ki ima prvič omenjenega drugega govornika -->
                            <xsl:otherwise>
                                <split type="sp"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:copy-of select="."/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:for-each-group select="$split/*" group-starting-with="tei:split"      >
            <div type="{self::tei:split/@type}">
                <xsl:for-each select="current-group()[not(self::tei:split)]">
                    <xsl:copy-of select="."/>
                </xsl:for-each> 
            </div>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template match="node()|@*" mode="govori-var6-doda_id">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" mode="govori-var6-doda_id"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:div" mode="govori-var6-doda_id">
        <xsl:variable name="divPosition" select="position()"/>
        <div xml:id="{concat('div-',$divPosition)}">
            <xsl:if test="@type">
                <xsl:attribute name="type">
                    <xsl:value-of select="@type"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:for-each select="tei:u[string-length(.) gt 0] | tei:anchor">
                <xsl:choose>
                    <xsl:when test="xs:string(node-name(.)) eq 'u'">
                        <u xml:id="{concat('sp-',$divPosition,'.',position())}" who="{@who}">
                            <xsl:call-template name="stage-type-attribute"/>
                            <!-- atr divId začasno shranim v atr corresp (uvodne komentatorjeve besede (docDate ipd.) nimajo tega atributa, zato preferem if) -->
                            <xsl:if test="@divId">
                                <xsl:attribute name="corresp">
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
            <xsl:if test="@type">
                <xsl:attribute name="type">
                    <xsl:value-of select="@type"/>
                </xsl:attribute>
            </xsl:if>
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
            <xsl:call-template name="ana-attribute"/>
            <xsl:call-template name="stage-type-attribute"/>
            <xsl:value-of select="normalize-space(.)"/>
        </u>
    </xsl:template>
    
    <xsl:template match="tei:anchor" mode="govori-var-11-ciscenje">
        <anchor xml:id="{@xml:id}"/>
    </xsl:template>
    
    <xsl:template name="taxonomy-toc-ana-attribute">
        <xsl:if test="tei:list[@type='contents']">
            <xsl:attribute name="ana">
                <xsl:for-each select="tei:list[@type='contents']//tei:item[@corresp]">
                    <xsl:value-of select="@corresp"/>
                    <xsl:if test="position() != last()">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="taxonomy-toc-topic">
        <xsl:if test="tei:list[@type='contents']">
            <catDesc xml:lang="sl">
                <xsl:attribute name="resp">
                    <xsl:value-of select="$link-to-toc-author"/>
                </xsl:attribute>
                <xsl:for-each select="tei:list[@type='contents']/tei:item/tei:list[tei:head]">
                    <xsl:variable name="level">
                        <xsl:number level="any" count="//tei:list[@type='contents']/tei:item/tei:list[tei:head]"/>
                    </xsl:variable>
                    <title xml:id="{concat('topic.',$level)}" type="topic">
                        <xsl:attribute name="ana">
                            <xsl:for-each select="tei:item[@corresp]">
                                <xsl:value-of select="@corresp"/>
                                <xsl:if test="position() != last()">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:attribute>
                        <xsl:value-of select="normalize-space(tei:head)"/>
                    </title>
                </xsl:for-each>
            </catDesc>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="taxonomy-toc-category">
        <xsl:for-each select="tei:list[not(@type)]/tei:item">
            <xsl:variable name="level">
                <xsl:number format="1.1.1.1.1" level="multiple" count="tei:list[not(@type)]/tei:item"/>
            </xsl:variable>
            <category xml:id="{concat('taxonomy.',$level)}">
                <xsl:call-template name="taxonomy-toc-ana-attribute"/>
                <xsl:for-each select="tei:term">
                    <catDesc>
                        <xsl:if test="@xml:lang">
                            <xsl:attribute name="xml:lang">
                                <xsl:value-of select="@xml:lang"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="."/>
                    </catDesc>
                </xsl:for-each>
                <xsl:call-template name="taxonomy-toc-topic"/>
                <xsl:call-template name="taxonomy-toc-category"/>
            </category>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="node()|@*" mode="taxonomy-remove_ana">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" mode="taxonomy-remove_ana"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:category" mode="taxonomy-remove_ana">
        <category xml:id="{@xml:id}">
            <xsl:apply-templates mode="taxonomy-remove_ana"/>
        </category>
    </xsl:template>
    
    <xsl:template match="tei:title[@type='topic']" mode="taxonomy-remove_ana">
        <title xml:id="{@xml:id}" type="topic">
            <xsl:apply-templates mode="taxonomy-remove_ana"/>
        </title>
    </xsl:template>
    
    <!-- vsi stage elementi imajo orgininalno atribut type, vrednost katerih je potrebno ohraniti,
        ker se na njihovi podalgi na koncu dodeluje type elementa note in incident -->
    <xsl:template name="stage-type-attribute">
        <xsl:if test="@type">
            <xsl:attribute name="type">
                <xsl:value-of select="@type"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="ana-attribute">
        <xsl:if test="@ana">
            <xsl:attribute name="ana">
                <xsl:value-of select="@ana"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="remove-parenthesis">
        <xsl:analyze-string select="." regex="^(\()(.*?)(\)?)$" flags="m">
            <xsl:matching-substring>
                <xsl:value-of select="normalize-space(regex-group(2))"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:analyze-string select="." regex="^(\()?(.*?)(\))$" flags="m">
                    <xsl:matching-substring>
                        <xsl:value-of select="normalize-space(regex-group(2))"/>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:value-of select="normalize-space(.)"/>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="note">
        <xsl:param name="uniqueId"/>
        <note xml:id="{concat($uniqueId,'.',@xml:id)}">
            <xsl:call-template name="stage-type-attribute"/>
            <xsl:call-template name="remove-parenthesis"/>
        </note>
    </xsl:template>
    
    
</xsl:stylesheet>