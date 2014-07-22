<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:parse="http://cdlib.org/xtf/parse"
   xmlns:xtf="http://cdlib.org/xtf"
   exclude-result-prefixes="#all">
   
   <!--
      Copyright (c) 2012, Regents of the University of California
      All rights reserved.
      
      Redistribution and use in source and binary forms, with or without 
      modification, are permitted provided that the following conditions are 
      met:
      
      - Redistributions of source code must retain the above copyright notice, 
      this list of conditions and the following disclaimer.
      - Redistributions in binary form must reproduce the above copyright 
      notice, this list of conditions and the following disclaimer in the 
      documentation and/or other materials provided with the distribution.
      - Neither the name of the University of California nor the names of its
      contributors may be used to endorse or promote products derived from 
      this software without specific prior written permission.
      
      THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
      AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
      IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
      ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
      LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
      CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
      SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
      INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
      CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
      ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
      POSSIBILITY OF SUCH DAMAGE.
   -->
   
   <!-- ====================================================================== -->
   <!-- Import Common Templates and Functions                                  -->
   <!-- ====================================================================== -->
   
   <xsl:import href="../common/preFilterCommon.xsl"/>

   <!-- ====================================================================== -->
   <!-- Import OAC EAD templates and functions                                 -->
   <!-- ====================================================================== -->
   
   <xsl:import href="./supplied-headings.xsl"/>
   <!-- xmlns:oac="http://oac.cdlib.org" oac:supply-heading -->
   <xsl:import href="./at2oac.xsl"/>
   
   <!-- ====================================================================== -->
   <!-- Output parameters                                                      -->
   <!-- ====================================================================== -->
   
   <xsl:output method="xml" 
      indent="yes" 
      encoding="UTF-8"/>

   <!-- ====================================================================== -->
   <!-- normalize the file to the EAD 2002 DTD                                 -->
   <!-- ====================================================================== -->

   <xsl:variable name="dtdVersion">
        <xsl:apply-templates mode="at2oac"/>
   </xsl:variable>
   
   <!-- ====================================================================== -->
   <!-- Default: identity transformation                                       -->
   <!-- ====================================================================== -->
   
   <xsl:template match="@*|node()">
      <xsl:copy>
         <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Root Template                                                          -->
   <!-- ====================================================================== -->
   
   <xsl:template match="/*">
         <xsl:apply-templates select="$dtdVersion" mode="root"/>
   </xsl:template>

   <xsl:template match="ead" mode="root">
      <xsl:copy>
         <xsl:namespace name="xtf" select="'http://cdlib.org/xtf'"/>
         <xsl:copy-of select="@*"/>
         <xsl:call-template name="get-meta"/>
         <xsl:apply-templates mode="addChunkId"/>
      </xsl:copy>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Top-level transformation: add chunk.id to each element                 -->
   <!-- ====================================================================== -->
   
   <xsl:template match="node()" mode="addChunkId">
      <xsl:call-template name="ead-copy">
         <xsl:with-param name="node" select="."/>
         <xsl:with-param name="chunk.id" select="xs:string(position())"/>
      </xsl:call-template>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Rearrange the archdesc section to be in display order                  -->
   <!-- ====================================================================== -->
   
   <xsl:template match="archdesc" mode="addChunkId">
      <xsl:copy>
         <xsl:copy-of select="@*"/>         
         
         <xsl:apply-templates mode="addChunkId" select="did"/>
         <xsl:apply-templates mode="addChunkId" select="bioghist"/>
         <xsl:apply-templates mode="addChunkId" select="scopecontent"/>
         <xsl:apply-templates mode="addChunkId" select="arrangement"/>

         <!-- archdesc-restrict -->
         <xsl:apply-templates mode="addChunkId" select="userestrict"/>
         <xsl:apply-templates mode="addChunkId" select="accessrestrict"/>

         <!-- archdesc-relatedmaterial -->
         <xsl:apply-templates mode="addChunkId" select="relatedmaterial"/>
         <xsl:apply-templates mode="addChunkId" select="separatedmaterial"/>
         
         <xsl:apply-templates mode="addChunkId" select="controlaccess"/>
         <xsl:apply-templates mode="addChunkId" select="odd"/>
         <xsl:apply-templates mode="addChunkId" select="originalsloc"/>
         <xsl:apply-templates mode="addChunkId" select="phystech"/>

         <!-- archdesc-admininfo -->
         <xsl:apply-templates mode="addChunkId" select="custodhist"/>
         <xsl:apply-templates mode="addChunkId" select="altformavail"/>
         <xsl:apply-templates mode="addChunkId" select="prefercite"/>
         <xsl:apply-templates mode="addChunkId" select="acqinfo"/>
         <xsl:apply-templates mode="addChunkId" select="processinfo"/>
         <xsl:apply-templates mode="addChunkId" select="appraisal"/>
         <xsl:apply-templates mode="addChunkId" select="accruals"/>

         <xsl:apply-templates mode="addChunkId" select="descgrp"/>
         <xsl:apply-templates mode="addChunkId" select="otherfindaid"/>
         <xsl:apply-templates mode="addChunkId" select="fileplan"/>
         <xsl:apply-templates mode="addChunkId" select="bibliography"/>
         <xsl:apply-templates mode="addChunkId" select="index"/>
         
         <!-- Lastly, the container list. -->
         <xsl:apply-templates mode="addChunkId" select="dsc"/>
      </xsl:copy>
   </xsl:template>

   <!-- Rearrange the <did> section to be in display order -->
   <xsl:template match="did" mode="addChunkId">
      <xsl:copy>
         <xsl:copy-of select="@*"/>         
         
         <xsl:apply-templates select="repository"/>
         <xsl:apply-templates select="origination"/>
         <xsl:apply-templates select="unittitle"/>
         <xsl:apply-templates select="unitdate"/>
         <xsl:apply-templates select="physdesc"/>
         <xsl:apply-templates select="abstract"/>
         <xsl:apply-templates select="unitid"/>
         <xsl:apply-templates select="physloc"/>
         <xsl:apply-templates select="langmaterial"/>
         <xsl:apply-templates select="materialspec"/>
         <xsl:apply-templates select="note"/>
      </xsl:copy>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Add a unique id to each child of archdesc and each c01, c02, and       --> 
   <!-- archdesc section...                                                    -->
   <!-- We do this by recording the position of each of the node's ancestors   -->
   <!-- (and the node itself)                                                  -->
   <!-- ====================================================================== -->
   
   <xsl:template name="ead-copy">
      <xsl:param name="node"/>
      <xsl:param name="chunk.id"/>

      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:choose>
            <xsl:when test="self::c01 or self::c02 or (self::* and (parent::archdesc or parent::ead))">
               <xsl:if test="not(@id)">
                  <xsl:attribute name="id" select="concat(local-name(), '_', $chunk.id)"/>
               </xsl:if>
               <xsl:if test="not($node/head)">
                  <xsl:variable name="heading" select="oac:supply-heading($node)" xmlns:oac="http://oac.cdlib.org"/>
                  <xsl:if test="$heading!=''">
                     <head><xsl:value-of select="$heading"/></head>
                  </xsl:if>
               </xsl:if>
               <xsl:for-each select="node()">
                  <xsl:call-template name="ead-copy">
                     <xsl:with-param name="node" select="."/>
                     <xsl:with-param name="chunk.id" select="concat($chunk.id, xtf:posToChar(position()))"/>
                  </xsl:call-template>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:apply-templates select="node()"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:copy>
   </xsl:template>
   
   <!-- Used to generate compact IDs by encoding numbers 1..26 as letters instead -->
   <xsl:function name="xtf:posToChar">
      <xsl:param name="pos"/>
      <xsl:value-of select="
         if ($pos &lt; 27) then
            substring('ABCDEFGHIJKLMNOPQRSTUVWXYZ', $pos, 1)
         else
            concat('.', $pos)"/>
   </xsl:function>
   
   <!-- ====================================================================== -->
   <!-- EAD Indexing                                                           -->
   <!-- ====================================================================== -->
   
   <!-- Ignored Elements -->
   <xsl:template match="eadheader" mode="addChunkId">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="xtf:index" select="'no'"/>
         <xsl:apply-templates mode="addChunkId"/>
      </xsl:copy>
   </xsl:template>
   
   
   <!-- sectionType Indexing and Element Boosting -->
   <xsl:template match="unittitle[parent::did]">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="xtf:sectionType" select="concat('head ', @type)"/>
         <xsl:attribute name="xtf:wordBoost" select="2.0"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="prefercite">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="xtf:sectionType" select="'citation'"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="titleproper[parent::titlestmt]">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="xtf:wordBoost" select="100.0"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>

   <!-- ====================================================================== -->
   <!-- Metadata Indexing                                                      -->
   <!-- ====================================================================== -->
   
   <xsl:template name="get-meta">
      <!-- Access Dublin Core Record (if present) -->
      <xsl:variable name="dcMeta">
         <xsl:call-template name="get-dc-meta"/>
      </xsl:variable>
      
      <!-- If no Dublin Core present, then extract meta-data from the EAD -->
      <xsl:variable name="meta">
         <xsl:choose>
            <xsl:when test="$dcMeta/*">
               <xsl:copy-of select="$dcMeta"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:call-template name="get-ead-title"/>
               <xsl:call-template name="get-ead-creator"/>
               <xsl:call-template name="get-ead-subject"/>
               <xsl:call-template name="get-ead-description"/>
               <xsl:call-template name="get-ead-publisher"/>
               <xsl:call-template name="get-ead-contributor"/>
               <xsl:call-template name="get-ead-date"/>
               <xsl:call-template name="get-ead-type"/>
               
               <!-- JB 3/31/2014 add to generate materials facet from genreform -->
               <xsl:call-template name="get-ead-genreform"/>
               
               <!-- HA 3/31/2014 adding additional facets -->
               <xsl:call-template name="get-ead-persname"/>
               <xsl:call-template name="get-ead-corpname"/>
               <xsl:call-template name="get-ead-geogname"/>
               <xsl:call-template name="get-ead-famname"/>
               <xsl:call-template name="get-ead-occupation"/>

               <xsl:call-template name="get-ead-format"/>
               <xsl:call-template name="get-ead-identifier"/>
               <xsl:call-template name="get-ead-source"/>
               <xsl:call-template name="get-ead-language"/>
               <xsl:call-template name="get-ead-relation"/>
               <xsl:call-template name="get-ead-coverage"/>
               <xsl:call-template name="get-ead-rights"/>
               <!-- special values for OAI -->
               <xsl:call-template name="oai-datestamp"/>
               <xsl:call-template name="oai-set"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <!-- Add display and sort fields to the data, and output the result. -->
      <xsl:call-template name="add-fields">
         <xsl:with-param name="display" select="'dynaxml'"/>
         <xsl:with-param name="meta" select="$meta"/>
      </xsl:call-template>    
   </xsl:template>
   
   <!-- title --> 
   <xsl:template name="get-ead-title">
      <xsl:choose>
         <xsl:when test="($dtdVersion)/ead/archdesc/did/unittitle">
            <title xtf:meta="true">
               <xsl:value-of select="($dtdVersion)/ead/archdesc/did/unittitle"/>
            </title>
         </xsl:when>
         <xsl:when test="($dtdVersion)/ead/eadheader/filedesc/titlestmt/titleproper">
            <xsl:variable name="titleproper" select="string(($dtdVersion)/ead/eadheader/filedesc/titlestmt/titleproper)"/>
            <xsl:variable name="subtitle" select="string(($dtdVersion)/ead/eadheader/filedesc/titlestmt/subtitle)"/>
            <title xtf:meta="true">
               <xsl:value-of select="$titleproper"/>
               <xsl:if test="$subtitle">
                  <!-- Put a colon between main and subtitle, if none present already -->
                  <xsl:if test="not(matches($titleproper, ':\s*$') or matches($subtitle, '^\s*:'))">
                     <xsl:text>: </xsl:text>
                  </xsl:if>  
                  <xsl:value-of select="$subtitle"/>
               </xsl:if>
            </title>
         </xsl:when>
         <xsl:otherwise>
            <title xtf:meta="true">
               <xsl:value-of select="'unknown'"/>
            </title>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- creator -->
   <xsl:template name="get-ead-creator">
      <xsl:choose>
         <!--HA 3/21/2014 adding selection of creator by role attribute -->
         <xsl:when test="($dtdVersion)/ead/archdesc/did/origination[starts-with(@label, 'Creator')]">
            <creator xtf:meta="true">
               <xsl:value-of select="string(($dtdVersion)/ead/archdesc/did/origination[@label, 'Creator'][1])"/>
            </creator>
         </xsl:when>
         <xsl:when test="($dtdVersion)/ead/archdesc/did/origination[starts-with(@role, 'creator')]">
            <creator xtf:meta="true">
               <xsl:value-of select="string(($dtdVersion)/ead/archdesc/did/origination[@role, 'creator'][1])"/>
            </creator>
         </xsl:when>
         <!-- HA 3/26/2014 adding selection of collector by role attribute -->
         <xsl:when test="($dtdVersion)/ead/archdesc/did/origination[starts-with(@label, 'Collector')]">
            <creator xtf:meta="true">
               <xsl:value-of select="string(($dtdVersion)/ead/archdesc/did/origination[@label, 'Collector'][1])"/>
            </creator>
         </xsl:when>
         <xsl:when test="($dtdVersion)/ead/archdesc/did/origination[starts-with(@label, 'collector')]">
            <creator xtf:meta="true">
               <xsl:value-of select="string(($dtdVersion)/ead/archdesc/did/origination[@label, 'collector'][1])"/>
            </creator>
         </xsl:when>
         <!-- HA 3/21/2014 disabling indexing of author in titlestmt -->
         <!--<xsl:when test="($dtdVersion)/ead/eadheader/filedesc/titlestmt/author">
            <creator xtf:meta="true">
               <xsl:value-of select="string(($dtdVersion)/ead/eadheader/filedesc/titlestmt/author[1])"/>
            </creator>
         </xsl:when>-->
         <xsl:otherwise>
            <creator xtf:meta="true">
               <xsl:value-of select="'unknown'"/>
            </creator>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- subject --> 
   <!-- Note: we use for-each-group below to remove duplicate entries. -->
   <xsl:template name="get-ead-subject">
      <xsl:choose>
         <xsl:when test="($dtdVersion)/ead/archdesc//controlaccess/subject">
            <xsl:for-each-group select="($dtdVersion)/ead/archdesc//controlaccess/subject" group-by="string()">
               <subject xtf:meta="true">
                  <xsl:value-of select="replace(normalize-space(.), '^(.*)[.]$', '$1')"/>
               </subject>
            </xsl:for-each-group>
         </xsl:when>
         <xsl:when test="($dtdVersion)/ead/eadheader/filedesc/notestmt/subject">
            <xsl:for-each-group select="($dtdVersion)/ead/eadheader/filedesc/notestmt/subject" group-by="string()">
               <subject xtf:meta="true">
                  <xsl:value-of select="replace(normalize-space(.), '^(.*)[.]$', '$1')"/>
               </subject>
            </xsl:for-each-group>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   
   <!-- description --> 
   <xsl:template name="get-ead-description">
      <xsl:choose>
         <xsl:when test="($dtdVersion)/ead/archdesc/did/abstract">
            <description xtf:meta="true">
               <xsl:value-of select="string(($dtdVersion)/ead/archdesc/did/abstract[1])"/>
            </description>
         </xsl:when>
         <xsl:when test="($dtdVersion)/ead/eadheader/filedesc/notestmt/note">
            <description xtf:meta="true">
               <xsl:value-of select="string(($dtdVersion)/ead/eadheader/filedesc/notestmt/note[1])"/>
            </description>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   
   <!-- publisher -->
   <xsl:template name="get-ead-publisher">
      <xsl:choose>
         <xsl:when test="($dtdVersion)/ead/eadheader/eadid/@mainagencycode">
            <publisher xtf:meta="true">
               <xsl:call-template name="publisher-list"/>
            </publisher>
         </xsl:when>
         <xsl:when test="($dtdVersion)/ead/eadheader/filedesc/publicationstmt/publisher">
            <publisher xtf:meta="true">
               <xsl:value-of select="normalize-space(($dtdVersion)/ead/eadheader/filedesc/publicationstmt/publisher[1])"/>
            </publisher>
         </xsl:when>
         <xsl:when test="($dtdVersion)/ead/archdesc/did/repository">
            <publisher xtf:meta="true">
               <xsl:value-of select="normalize-space(($dtdVersion)/ead/archdesc/did/repository[1])"/>
            </publisher>
         </xsl:when>
         <xsl:otherwise>
            <publisher xtf:meta="true">
               <xsl:value-of select="'unknown'"/>
            </publisher>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- publisher list -->
   <xsl:template name="publisher-list">
      <xsl:variable name="agencycode">
         <xsl:variable name="lowercase">
            <xsl:value-of select="lower-case(($dtdVersion)/ead/eadheader/eadid/@mainagencycode)"/>
         </xsl:variable>
         <xsl:choose>
            <xsl:when test="contains($lowercase, 'us-')">
               <xsl:variable name="substring">
                  <xsl:value-of select="substring-after($lowercase, 'us-')"/>
               </xsl:variable> 
               <xsl:value-of select="replace($substring, '-', '')"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="replace($lowercase, '-', '')"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="$agencycode = 'nalsu'">
            <xsl:text>M. E. Grenander Department of Special Collections and Archives</xsl:text>
         </xsl:when>
         <xsl:when test="$agencycode = 'ngca'">
            <xsl:text>Adelphi University</xsl:text>
         </xsl:when>
         <xsl:when test="$agencycode = 'nnan'">
            <xsl:text>American Numismatic Soci  ety Archives</xsl:text>
         </xsl:when>
         <xsl:when test="$agencycode = 'nyblhs'">
               <xsl:text>Brooklyn Historical Society</xsl:text>
         </xsl:when>
         <xsl:when test="$agencycode = 'nynycjh'">
               <xsl:text>Center for Jewish History</xsl:text>
         </xsl:when>
         <xsl:when test="$agencycode = 'nnca'">
               <xsl:text>Avery Architecture and Fine Arts Library. Department of Drawings and Archives.</xsl:text>
         </xsl:when>
         <xsl:when test="$agencycode = 'nncrb'">
               <xsl:text>Rare Book and Manuscript Library. Columbia University Libraries</xsl:text>
         </xsl:when>
         <xsl:when test="$agencycode = 'nncua'">
            <xsl:text>Rare Book and Manuscript Library. Columbia University Libraries</xsl:text>
         </xsl:when>
         <xsl:when test="$agencycode = 'nic'">
               <xsl:text>Cornell University</xsl:text>
         </xsl:when>
         <xsl:when test="$agencycode = 'nhyf'">
               <xsl:text>Franklin D. Roosevelt Presidential Library and Museum</xsl:text>            
         </xsl:when>
         <xsl:when test="$agencycode = 'nnmoma'">
               <xsl:text>The Museum of Modern Art Archives</xsl:text>
         </xsl:when>
         <xsl:when test="$agencycode = 'nnns'">
               <xsl:text>Kellen Design Archives</xsl:text>
         </xsl:when>
         <xsl:when test="$agencycode = 'nn'">
               <xsl:text>The New York Public Library</xsl:text>
         </xsl:when>
         <xsl:when test="$agencycode = 'nsy'">
               <xsl:text>Onondaga County Public Library</xsl:text>
         </xsl:when>
         <xsl:when test="$agencycode = 'nnttr'">
               <xsl:text>Rockefeller Archive Center</xsl:text>
         </xsl:when>
         <xsl:when test="$agencycode = 'nbuuar'">
               <xsl:text>State University of New York at Buffalo. University Archives</xsl:text>
         </xsl:when>
         <xsl:when test="$agencycode = 'nsyohi'">
               <xsl:text>The Onondaga Historical Association</xsl:text>
         </xsl:when>
         <xsl:when test="$agencycode = 'nngu'">
            <xsl:text>Solomon R. Guggenheim Museum Archives</xsl:text>
         </xsl:when>
         <xsl:when test="$agencycode = 'nbuul'">
               <xsl:text>State University of New York at Buffalo. Charles B. Sears Law Library</xsl:text>
         </xsl:when>
         <xsl:when test="$agencycode = 'nbuumu'">
               <xsl:text>State University of New York at Buffalo. Music Library</xsl:text>
         </xsl:when>
         <xsl:when test="$agencycode = 'nbuupo'">
               <xsl:text>State University of New York at Buffalo. Poetry Collection</xsl:text>
         </xsl:when>
         <xsl:when test="$agencycode = 'nsyu'">
               <xsl:text>Syracuse University</xsl:text>
         </xsl:when>
         <xsl:when test="$agencycode = 'vxw'">
               <xsl:text>Archives and Special Collections Library, Vassar College Libraries</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$agencycode"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
  
   <!-- contributor -->
   <xsl:template name="get-ead-contributor">
      <xsl:choose>
         <xsl:when test="($dtdVersion)/ead/eadheader/filedesc/titlestmt/author">
            <contributor xtf:meta="true">
               <xsl:value-of select="string(($dtdVersion)/ead/eadheader/filedesc/titlestmt/author[1])"/>
            </contributor>
         </xsl:when>
         <xsl:otherwise>
            <contributor xtf:meta="true">
               <xsl:value-of select="'unknown'"/>
            </contributor>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- date --> 
   <xsl:template name="get-ead-date">
      <xsl:choose>
         <xsl:when test="($dtdVersion)/ead/archdesc/did/unitdate">
            <date xtf:meta="true">
               <xsl:value-of select="($dtdVersion)/ead/archdesc/did/unitdate"/>
            </date>
         </xsl:when>
         <xsl:when test="($dtdVersion)/ead/archdesc/did/unittitle/unitdate">
            <date xtf:meta="true">
               <xsl:value-of select="($dtdVersion)/ead/archdesc/did/unittitle/unitdate"/>
            </date>
         </xsl:when>
         <xsl:otherwise>
            <date xtf:meta="true">
               <xsl:value-of select="'unknown'"/>
            </date>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- type -->
   <xsl:template name="get-ead-type">
      <type xtf:meta="true">ead</type>
   </xsl:template>
   
   <!-- JB 3/31/2014 add to generate materials facet from genreform -->
   <xsl:template name="get-ead-genreform">
      <xsl:choose>
         <xsl:when test="($dtdVersion)/ead/archdesc/controlaccess/genreform">
            <xsl:for-each-group select="($dtdVersion)/ead/archdesc/controlaccess/genreform"
               group-by="string()">
               <genreform xtf:meta="true">
                  <xsl:value-of select="replace(normalize-space(.), '^(.*)[.]$', '$1')"/>
               </genreform>
            </xsl:for-each-group>
         </xsl:when>
         <xsl:when test="($dtdVersion)/ead/archdesc//controlaccess/genreform">
            <xsl:for-each-group select="($dtdVersion)/ead/archdesc//controlaccess/genreform"
               group-by="string()">
               <genreform xtf:meta="true">
                  <xsl:value-of select="replace(normalize-space(.), '^(.*)[.]$', '$1')"/>
               </genreform>
            </xsl:for-each-group>
         </xsl:when>
         <!-- add to account for nesting of control access -->
         <xsl:when test="($dtdVersion)/ead/archdesc//controlaccess/*/genreform">
            <xsl:for-each-group select="($dtdVersion)/ead/archdesc//controlaccess/*/genreform"
               group-by="string()">
               <genreform xtf:meta="true">
                  <xsl:value-of select="replace(normalize-space(.), '^(.*)[.]$', '$1')"/>
               </genreform>
            </xsl:for-each-group>
         </xsl:when>
         <!-- will NYEAD use  -->
         <xsl:when test="($dtdVersion)/ead/eadheader/filedesc/notestmt/genreform">
            <xsl:for-each-group select="($dtdVersion)/ead/eadheader/filedesc/notestmt/genreform"
               group-by="string()">
               <genreform xtf:meta="true">
                  <xsl:value-of select="replace(normalize-space(.), '^(.*)[.]$', '$1')"/>
               </genreform>
            </xsl:for-each-group>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   
   <!-- persname -->
   <xsl:template name="get-ead-persname">
      <xsl:choose>
         <xsl:when test="($dtdVersion)/ead/archdesc/controlaccess/persname">
            <xsl:for-each-group select="($dtdVersion)/ead/archdesc/controlaccess/persname"
               group-by="string()">
               <persname xtf:meta="true">
                  <xsl:value-of select="replace(normalize-space(.), '^(.*)[.]$', '$1')"/>
               </persname>
            </xsl:for-each-group>
         </xsl:when>
         <xsl:when test="($dtdVersion)/ead/archdesc//controlaccess/persname">
            <xsl:for-each-group select="($dtdVersion)/ead/archdesc//controlaccess/persname"
               group-by="string()">
               <persname xtf:meta="true">
                  <xsl:value-of select="replace(normalize-space(.), '^(.*)[.]$', '$1')"/>
               </persname>
            </xsl:for-each-group>
         </xsl:when>
         <!-- add to account for nesting of control access -->
         <xsl:when test="($dtdVersion)/ead/archdesc//controlaccess/*/persname">
            <xsl:for-each-group select="($dtdVersion)/ead/archdesc//controlaccess/*/persname"
               group-by="string()">
               <persname xtf:meta="true">
                  <xsl:value-of select="replace(normalize-space(.), '^(.*)[.]$', '$1')"/>
               </persname>
            </xsl:for-each-group>
         </xsl:when>
         <!-- will NYEAD use  -->
         <xsl:when test="($dtdVersion)/ead/eadheader/filedesc/notestmt/persname">
            <xsl:for-each-group select="($dtdVersion)/ead/eadheader/filedesc/notestmt/persname"
               group-by="string()">
               <persname xtf:meta="true">
                  <xsl:value-of select="replace(normalize-space(.), '^(.*)[.]$', '$1')"/>
               </persname>
            </xsl:for-each-group>
         </xsl:when>
      </xsl:choose>
   </xsl:template>     
         
   <!-- corpname -->
   <xsl:template name="get-ead-corpname">
      <xsl:choose>
         <xsl:when test="($dtdVersion)/ead/archdesc/controlaccess/corpname">
            <xsl:for-each-group select="($dtdVersion)/ead/archdesc/controlaccess/corpname"
               group-by="string()">
               <corpname xtf:meta="true">
                  <xsl:value-of select="replace(normalize-space(.), '^(.*)[.]$', '$1')"/>
               </corpname>
            </xsl:for-each-group>
         </xsl:when>
         <xsl:when test="($dtdVersion)/ead/archdesc//controlaccess/corpname">
            <xsl:for-each-group select="($dtdVersion)/ead/archdesc//controlaccess/corpname"
               group-by="string()">
               <corpname xtf:meta="true">
                  <xsl:value-of select="replace(normalize-space(.), '^(.*)[.]$', '$1')"/>
               </corpname>
            </xsl:for-each-group>
         </xsl:when>
         <!-- add to account for nesting of control access -->
         <xsl:when test="($dtdVersion)/ead/archdesc//controlaccess/*/corpname">
            <xsl:for-each-group select="($dtdVersion)/ead/archdesc//controlaccess/*/corpname"
               group-by="string()">
               <corpname xtf:meta="true">
                  <xsl:value-of select="replace(normalize-space(.), '^(.*)[.]$', '$1')"/>
               </corpname>
            </xsl:for-each-group>
         </xsl:when>
         <!-- will NYEAD use  -->
         <xsl:when test="($dtdVersion)/ead/eadheader/filedesc/notestmt/corpname">
            <xsl:for-each-group select="($dtdVersion)/ead/eadheader/filedesc/notestmt/corpname"
               group-by="string()">
               <corpname xtf:meta="true">
                  <xsl:value-of select="replace(normalize-space(.), '^(.*)[.]$', '$1')"/>
               </corpname>
            </xsl:for-each-group>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   
   <!-- famname -->
   <xsl:template name="get-ead-famname">
      <xsl:choose>
         <xsl:when test="($dtdVersion)/ead/archdesc/controlaccess/famname">
            <xsl:for-each-group select="($dtdVersion)/ead/archdesc/controlaccess/famname"
               group-by="string()">
               <famname xtf:meta="true">
                  <xsl:value-of select="replace(normalize-space(.), '^(.*)[.]$', '$1')"/>
               </famname>
            </xsl:for-each-group>
         </xsl:when>
         <xsl:when test="($dtdVersion)/ead/archdesc//controlaccess/famname">
            <xsl:for-each-group select="($dtdVersion)/ead/archdesc//controlaccess/famname"
               group-by="string()">
               <famname xtf:meta="true">
                  <xsl:value-of select="replace(normalize-space(.), '^(.*)[.]$', '$1')"/>
               </famname>
            </xsl:for-each-group>
         </xsl:when>
         <!-- add to account for nesting of control access -->
         <xsl:when test="($dtdVersion)/ead/archdesc//controlaccess/*/famname">
            <xsl:for-each-group select="($dtdVersion)/ead/archdesc//controlaccess/*/famname"
               group-by="string()">
               <famname xtf:meta="true">
                  <xsl:value-of select="replace(normalize-space(.), '^(.*)[.]$', '$1')"/>
               </famname>
            </xsl:for-each-group>
         </xsl:when>
         <!-- will NYEAD use  -->
         <xsl:when test="($dtdVersion)/ead/eadheader/filedesc/notestmt/famname">
            <xsl:for-each-group select="($dtdVersion)/ead/eadheader/filedesc/notestmt/famname"
               group-by="string()">
               <famname xtf:meta="true">
                  <xsl:value-of select="replace(normalize-space(.), '^(.*)[.]$', '$1')"/>
               </famname>
            </xsl:for-each-group>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   
   <!-- occupation -->
   <xsl:template name="get-ead-occupation">
      <xsl:choose>
         <xsl:when test="($dtdVersion)/ead/archdesc/controlaccess/occupation">
            <xsl:for-each-group select="($dtdVersion)/ead/archdesc/controlaccess/occupation"
               group-by="string()">
               <occupation xtf:meta="true">
                  <xsl:value-of select="replace(normalize-space(.), '^(.*)[.]$', '$1')"/>
               </occupation>
            </xsl:for-each-group>
         </xsl:when>
         <xsl:when test="($dtdVersion)/ead/archdesc//controlaccess/occupation">
            <xsl:for-each-group select="($dtdVersion)/ead/archdesc//controlaccess/occupation"
               group-by="string()">
               <occupation xtf:meta="true">
                  <xsl:value-of select="replace(normalize-space(.), '^(.*)[.]$', '$1')"/>
               </occupation>
            </xsl:for-each-group>
         </xsl:when>
         <!-- add to account for nesting of control access -->
         <xsl:when test="($dtdVersion)/ead/archdesc//controlaccess/*/occupation">
            <xsl:for-each-group select="($dtdVersion)/ead/archdesc//controlaccess/*/occupation"
               group-by="string()">
               <occupation xtf:meta="true">
                  <xsl:value-of select="replace(normalize-space(.), '^(.*)[.]$', '$1')"/>
               </occupation>
            </xsl:for-each-group>
         </xsl:when>
         <!-- will NYEAD use  -->
         <xsl:when test="($dtdVersion)/ead/eadheader/filedesc/notestmt/occupation">
            <xsl:for-each-group select="($dtdVersion)/ead/eadheader/filedesc/notestmt/occupation"
               group-by="string()">
               <occupation xtf:meta="true">
                  <xsl:value-of select="replace(normalize-space(.), '^(.*)[.]$', '$1')"/>
               </occupation>
            </xsl:for-each-group>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   
   <!-- geogname -->
   <xsl:template name="get-ead-geogname">
      <xsl:choose>
         <xsl:when test="($dtdVersion)/ead/archdesc/controlaccess/geogname">
            <xsl:for-each-group select="($dtdVersion)/ead/archdesc/controlaccess/geogname"
               group-by="string()">
               <geogname xtf:meta="true">
                  <xsl:value-of select="replace(normalize-space(.), '^(.*)[.]$', '$1')"/>
               </geogname>
            </xsl:for-each-group>
         </xsl:when>
         <xsl:when test="($dtdVersion)/ead/archdesc//controlaccess/geogname">
            <xsl:for-each-group select="($dtdVersion)/ead/archdesc//controlaccess/geogname"
               group-by="string()">
               <geogname xtf:meta="true">
                  <xsl:value-of select="replace(normalize-space(.), '^(.*)[.]$', '$1')"/>
               </geogname>
            </xsl:for-each-group>
         </xsl:when>
         <!-- add to account for nesting of control access -->
         <xsl:when test="($dtdVersion)/ead/archdesc//controlaccess/*/geogname">
            <xsl:for-each-group select="($dtdVersion)/ead/archdesc//controlaccess/*/geogname"
               group-by="string()">
               <geogname xtf:meta="true">
                  <xsl:value-of select="replace(normalize-space(.), '^(.*)[.]$', '$1')"/>
               </geogname>
            </xsl:for-each-group>
         </xsl:when>
         <!-- will NYEAD use  -->
         <xsl:when test="($dtdVersion)/ead/eadheader/filedesc/notestmt/geogname">
            <xsl:for-each-group select="($dtdVersion)/ead/eadheader/filedesc/notestmt/geogname"
               group-by="string()">
               <geogname xtf:meta="true">
                  <xsl:value-of select="replace(normalize-space(.), '^(.*)[.]$', '$1')"/>
               </geogname>
            </xsl:for-each-group>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   
   <!-- format -->
   <xsl:template name="get-ead-format">
      <format xtf:meta="true">xml</format>
   </xsl:template>
   
   <!-- identifier --> 
   <xsl:template name="get-ead-identifier">
      <xsl:choose>
         <xsl:when test="($dtdVersion)/ead/archdesc/did/unitid">
            <identifier xtf:meta="true" xtf:tokenize="no">
               <xsl:value-of select="string(/ead/archdesc/did/unitid[1])"/>
            </identifier>
         </xsl:when>
         <xsl:when test="($dtdVersion)/ead/eadheader/eadid" xtf:tokenize="no">
            <identifier xtf:meta="true" xtf:tokenize="no">
               <xsl:value-of select="string(($dtdVersion)/ead/eadheader/eadid[1])"/>
            </identifier>
         </xsl:when>
         <xsl:otherwise>
            <identifier xtf:meta="true" xtf:tokenize="no">
               <xsl:value-of select="'unknown'"/>
            </identifier>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- source -->
   <xsl:template name="get-ead-source">
      <source xtf:meta="true">unknown</source>
   </xsl:template>
   
   <!-- language -->
   <xsl:template name="get-ead-language">
      <xsl:choose>
         <xsl:when test="($dtdVersion)/ead/eadheader/profiledesc/langusage/language">
            <language xtf:meta="true">
               <xsl:value-of select="string(($dtdVersion)/ead/eadheader/profiledesc/langusage/language[1])"/>
            </language>
         </xsl:when>
         <xsl:otherwise>
            <language xtf:meta="true">
               <xsl:value-of select="'english'"/>
            </language>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- relation -->
   <xsl:template name="get-ead-relation">
      <relation xtf:meta="true">unknown</relation>
   </xsl:template>
   
   <!-- coverage -->
   <xsl:template name="get-ead-coverage">
      <xsl:choose>
         <xsl:when test="($dtdVersion)/ead/archdesc/did/unittitle/unitdate">
            <coverage xtf:meta="true">
               <xsl:value-of select="string(($dtdVersion)/ead/archdesc/did/unittitle/unitdate[1])"/>
            </coverage>
         </xsl:when>
         <xsl:otherwise>
            <coverage xtf:meta="true">
               <xsl:value-of select="'unknown'"/>
            </coverage>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- rights -->
   <xsl:template name="get-ead-rights">
      <rights xtf:meta="true">public</rights>
   </xsl:template>
   
   <!-- OAI dateStamp -->
   <xsl:template name="oai-datestamp" xmlns:FileUtils="java:org.cdlib.xtf.xslt.FileUtils">
      <xsl:variable name="filePath" select="saxon:system-id()" xmlns:saxon="http://saxon.sf.net/"/>
      <dateStamp xtf:meta="true" xtf:tokenize="no">
         <xsl:value-of select="FileUtils:lastModified($filePath, 'yyyy-MM-dd')"/>
      </dateStamp>
   </xsl:template>
   
   <!-- OAI sets -->
   <xsl:template name="oai-set">
      <xsl:for-each-group select="($dtdVersion)/ead/archdesc//controlaccess/subject" group-by="string()">
         <set xtf:meta="true">
            <xsl:value-of select="."/>
         </set>
      </xsl:for-each-group>
      <xsl:for-each-group select="($dtdVersion)/ead/eadheader/filedesc/notestmt/subject" group-by="string()">
         <set xtf:meta="true">
            <xsl:value-of select="."/>
         </set>
      </xsl:for-each-group>
      <set xtf:meta="true">
         <xsl:value-of select="'public'"/>
      </set>
   </xsl:template>

</xsl:stylesheet>
