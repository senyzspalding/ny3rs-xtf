<!-- EAD Cookbook Style 7      Version 0.9   19 January 2004 -->
<!--  This stylesheet generates a Table of Contents in an HTML frame along
   the left side of the screen. It is an update to eadcbs3.xsl designed
   to work with EAD 2002.-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xtf="http://cdlib.org/xtf" exclude-result-prefixes="#all" version="1.0">

	<!-- Creates a variable equal to the value of the number in eadid which serves as the base
      for file names for the various components of the frameset.-->
	<xsl:variable name="file">
		<xsl:value-of select="ead/eadheader/eadid"/>
	</xsl:variable>

	<!--This template creates HTML meta tags that are inserted into the HTML ouput
      for use by web search engines indexing this file.   The content of each
      resulting META tag uses Dublin Core semantics and is drawn from the text of
      the finding aid.-->
	<xsl:template name="metadata">
		<meta http-equiv="Content-Type" name="dc.title" content="{eadheader/filedesc/titlestmt/titleproper&#x20; }{eadheader/filedesc/titlestmt/subtitle}"/>
		<meta http-equiv="Content-Type" name="dc.author" content="{archdesc/did/origination}"/>

		<xsl:for-each select="xtf:meta/subject">
			<meta http-equiv="Content-Type" name="dc.subject" content="{.}"/>
		</xsl:for-each>

		<meta http-equiv="Content-Type" name="dc.title" content="{archdesc/did/unittitle}"/>
		<meta http-equiv="Content-Type" name="dc.type" content="text"/>
		<meta http-equiv="Content-Type" name="dc.format" content="manuscripts"/>
		<meta http-equiv="Content-Type" name="dc.format" content="finding aids"/>

	</xsl:template>

	<!-- Creates the body of the finding aid.-->
	<xsl:template name="body">
		<!-- HA 3/14/2014 Need to call missing templates, including bioghist, scopecontent, etc here -->	
		<xsl:apply-templates select="archdesc/bioghist"/>
		<xsl:apply-templates select="archdesc/scopecontent"/>
		<xsl:apply-templates select="archdesc/arrangement"/>
		<xsl:call-template name="archdesc-restrict"/>
		<xsl:apply-templates select="archdesc/controlaccess"/>
		<xsl:call-template name="archdesc-relatedmaterial"/>
		<xsl:call-template name="archdesc-admininfo"/>
		<xsl:apply-templates select="descendant::dsc"/>
		

		<!-- <xsl:choose>
				<xsl:when test="$chunk.id = 'headerlink'">
				<xsl:apply-templates select="eadheader"/>
				<xsl:apply-templates select="archdesc/did"/>
			</xsl:when>
			<xsl:when test="$chunk.id = 'restrictlink'">
				<xsl:call-template name="archdesc-restrict"/>
			</xsl:when>
			<xsl:when test="$chunk.id = 'relatedmatlink'">
				<xsl:call-template name="archdesc-relatedmaterial"/>
			</xsl:when>
			<xsl:when test="$chunk.id = 'adminlink'">
				<xsl:call-template name="archdesc-admininfo"/>
			</xsl:when>
			<xsl:when test="$chunk.id != 0">
				<xsl:apply-templates select="key('chunk-id', $chunk.id)"/>
			</xsl:when>
			<xsl:otherwise>
				
				<xsl:apply-templates select="eadheader"/>
				<xsl:apply-templates select="archdesc/did"/>
			</xsl:otherwise>
		</xsl:choose> -->
	</xsl:template>


	<!-- The following general templates format the display of various RENDER
      attributes.-->
	<xsl:template match="emph[@render='bold']">
		<b>
			<xsl:apply-templates/>
		</b>
	</xsl:template>
	<xsl:template match="emph[@render='italic']">
		<i>
			<xsl:apply-templates/>
		</i>
	</xsl:template>
	<xsl:template match="emph[@render='underline']">
		<u>
			<xsl:apply-templates/>
		</u>
	</xsl:template>
	<xsl:template match="emph[@render='sub']">
		<sub>
			<xsl:apply-templates/>
		</sub>
	</xsl:template>
	<xsl:template match="emph[@render='super']">
		<super>
			<xsl:apply-templates/>
		</super>
	</xsl:template>

	<xsl:template match="emph[@render='quoted']">
		<xsl:text>"</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>"</xsl:text>
	</xsl:template>

	<xsl:template match="emph[@render='doublequote']">
		<xsl:text>"</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>"</xsl:text>
	</xsl:template>
	<xsl:template match="emph[@render='singlequote']">
		<xsl:text>'</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>'</xsl:text>
	</xsl:template>
	<xsl:template match="emph[@render='bolddoublequote']">
		<b>
			<xsl:text>"</xsl:text>
			<xsl:apply-templates/>
			<xsl:text>"</xsl:text>
		</b>
	</xsl:template>
	<xsl:template match="emph[@render='boldsinglequote']">
		<b>
			<xsl:text>'</xsl:text>
			<xsl:apply-templates/>
			<xsl:text>'</xsl:text>
		</b>
	</xsl:template>
	<xsl:template match="emph[@render='boldunderline']">
		<b>
			<u>
				<xsl:apply-templates/>
			</u>
		</b>
	</xsl:template>
	<xsl:template match="emph[@render='bolditalic']">
		<b>
			<i>
				<xsl:apply-templates/>
			</i>
		</b>
	</xsl:template>
	<xsl:template match="emph[@render='boldsmcaps']">
		<font style="font-variant: small-caps">
			<b>
				<xsl:apply-templates/>
			</b>
		</font>
	</xsl:template>
	<xsl:template match="emph[@render='smcaps']">
		<font style="font-variant: small-caps">
			<xsl:apply-templates/>
		</font>
	</xsl:template>
	<xsl:template match="title[@render='bold']">
		<b>
			<xsl:apply-templates/>
		</b>
	</xsl:template>
	<xsl:template match="title[@render='italic']">
		<i>
			<xsl:apply-templates/>
		</i>
	</xsl:template>
	<xsl:template match="title[@render='underline']">
		<u>
			<xsl:apply-templates/>
		</u>
	</xsl:template>
	<xsl:template match="title[@render='sub']">
		<sub>
			<xsl:apply-templates/>
		</sub>
	</xsl:template>
	<xsl:template match="title[@render='super']">
		<super>
			<xsl:apply-templates/>
		</super>
	</xsl:template>

	<xsl:template match="title[@render='quoted']">
		<xsl:text>"</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>"</xsl:text>
	</xsl:template>

	<xsl:template match="title[@render='doublequote']">
		<xsl:text>"</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>"</xsl:text>
	</xsl:template>

	<xsl:template match="title[@render='singlequote']">
		<xsl:text>'</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>'</xsl:text>
	</xsl:template>
	<xsl:template match="title[@render='bolddoublequote']">
		<b>
			<xsl:text>"</xsl:text>
			<xsl:apply-templates/>
			<xsl:text>"</xsl:text>
		</b>
	</xsl:template>
	<xsl:template match="title[@render='boldsinglequote']">
		<b>
			<xsl:text>'</xsl:text>
			<xsl:apply-templates/>
			<xsl:text>'</xsl:text>
		</b>
	</xsl:template>

	<xsl:template match="title[@render='boldunderline']">
		<b>
			<u>
				<xsl:apply-templates/>
			</u>
		</b>
	</xsl:template>
	<xsl:template match="title[@render='bolditalic']">
		<b>
			<i>
				<xsl:apply-templates/>
			</i>
		</b>
	</xsl:template>
	<xsl:template match="title[@render='boldsmcaps']">
		<font style="font-variant: small-caps">
			<b>
				<xsl:apply-templates/>
			</b>
		</font>
	</xsl:template>
	<xsl:template match="title[@render='smcaps']">
		<font style="font-variant: small-caps">
			<xsl:apply-templates/>
		</font>
	</xsl:template>
	<!-- This template converts a Ref element into an HTML anchor.-->
	<xsl:template match="ref">
		<a href="#{@target}">
			<xsl:apply-templates/>
		</a>
	</xsl:template>

	<!--This template rule formats a list element anywhere
      except in arrangement.-->
	<xsl:template match="list[parent::*[not(self::arrangement)]]/head">
		<div style="margin-left: 25pt">
			<b>
				<xsl:apply-templates/>
			</b>
		</div>
	</xsl:template>

	<xsl:template match="list[parent::*[not(self::arrangement)]]/item">
		<div style="margin-left: 40pt">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<!--Formats a simple table. The width of each column is defined by the colwidth attribute in a colspec element.-->
	<xsl:template match="table">
		<table width="75%" style="margin-left: 25pt">
			<tr>
				<td colspan="3">
					<h4>
						<xsl:apply-templates select="head"/>
					</h4>
				</td>
			</tr>
			<xsl:for-each select="tgroup">
				<tr>
					<xsl:for-each select="colspec">
						<td width="{@colwidth}"/>
					</xsl:for-each>
				</tr>
				<xsl:for-each select="thead">
					<xsl:for-each select="row">
						<tr>
							<xsl:for-each select="entry">
								<td valign="top">
									<b>
										<xsl:apply-templates/>
									</b>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:for-each>
				</xsl:for-each>

				<xsl:for-each select="tbody">
					<xsl:for-each select="row">
						<tr>
							<xsl:for-each select="entry">
								<td valign="top">
									<xsl:apply-templates/>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:for-each>
		</table>
	</xsl:template>
	<!--This template rule formats a chronlist element.-->
	<xsl:template match="chronlist">
		<table width="100%" style="margin-left:25pt">
			<tr>
				<td width="5%"> </td>
				<td width="15%"> </td>
				<td width="80%"> </td>
			</tr>
			<xsl:apply-templates/>
		</table>
	</xsl:template>

	<xsl:template match="chronlist/head">
		<tr>
			<td colspan="3">
				<h4>
					<xsl:apply-templates/>
				</h4>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="chronlist/listhead">
		<tr>
			<td> </td>
			<td>
				<b>
					<xsl:apply-templates select="head01"/>
				</b>
			</td>
			<td>
				<b>
					<xsl:apply-templates select="head02"/>
				</b>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="chronitem">
		<!--Determine if there are event groups.-->
		<xsl:choose>
			<xsl:when test="eventgrp">
				<!--Put the date and first event on the first line.-->
				<tr>
					<td> </td>
					<td valign="top">
						<xsl:apply-templates select="date"/>
					</td>
					<td valign="top">
						<xsl:apply-templates select="eventgrp/event[position()=1]"/>
					</td>
				</tr>
				<!--Put each successive event on another line.-->
				<xsl:for-each select="eventgrp/event[not(position()=1)]">
					<tr>
						<td> </td>
						<td> </td>
						<td valign="top">
							<xsl:apply-templates select="."/>
						</td>
					</tr>
				</xsl:for-each>
			</xsl:when>
			<!--Put the date and event on a single line.-->
			<xsl:otherwise>
				<tr>
					<td> </td>
					<td valign="top">
						<xsl:apply-templates select="date"/>
					</td>
					<td valign="top">
						<xsl:apply-templates select="event"/>
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--Suppreses all other elements of eadheader.-->
	<xsl:template match="eadheader">
		<h2 style="text-align:center">
			<xsl:value-of select="filedesc/titlestmt/titleproper"/>
		</h2>
		<h3 style="text-align:center">
			<xsl:value-of select="filedesc/titlestmt/subtitle"/>
		</h3>
	<h4 style="text-align:center">
<xsl:value-of select="filedesc/titlestmt/author"/>
</h4>
<h4 style="text-align:center">
<xsl:value-of select="filedesc/titlestmt/sponsor"/>
</h4>
	</xsl:template>

	<!--This template creates a table for the did, inserts the head and then
      each of the other did elements.  To change the order of appearance of these
      elements, change the sequence of the apply-templates statements.-->
	<xsl:template match="archdesc/did">
		<dl class="dl-horizontal">
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
		</dl>
	</xsl:template>



	<!--This template formats the repostory, origination, physdesc, abstract,
      unitid, physloc and materialspec elements of archdesc/did which share a common presentaiton.
      The sequence of their appearance is governed by the previous template.-->
	<xsl:template
		match="archdesc/did/repository
      | archdesc/did/origination
      | archdesc/did/physdesc
      | archdesc/did/unitid
      | archdesc/did/physloc
      | archdesc/did/abstract
      | archdesc/did/langmaterial
      | archdesc/did/materialspec">
		<!--The template tests to see if there is a label attribute,
         inserting the contents if there is or adding display textif there isn't.
         The content of the supplied label depends on the element.  To change the
         supplied label, simply alter the template below.-->

		<dt>
			<xsl:choose>
				<xsl:when test="@label">
					<xsl:value-of select="@label"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="self::repository">
							<xsl:text>Repository</xsl:text>
						</xsl:when>
						<xsl:when test="self::origination">
							<xsl:text>Creator</xsl:text>
						</xsl:when>
						<xsl:when test="self::physdesc">
							<xsl:text>Quantity</xsl:text>
						</xsl:when>
						<xsl:when test="self::physloc">
							<xsl:text>Location</xsl:text>
						</xsl:when>
						<xsl:when test="self::unitid">
							<xsl:text>Identification</xsl:text>
						</xsl:when>
						<xsl:when test="self::abstract">
							<xsl:text>Abstract</xsl:text>
						</xsl:when>
						<xsl:when test="self::langmaterial">
							<xsl:text>Language</xsl:text>
						</xsl:when>
						<xsl:when test="self::materialspec">
							<xsl:text>Technical</xsl:text>
						</xsl:when>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</dt>
		<dd>
			<xsl:apply-templates/>
		</dd>
	</xsl:template>


	<!-- The following two templates test for and processes various permutations
      of unittitle and unitdate.-->
	<xsl:template match="archdesc/did/unittitle">
		<!--The template tests to see if there is a label attribute for unittitle,
		inserting the contents if there is or adding one if there isn't. -->

		<dt>
			<xsl:choose>
				<xsl:when test="@label">
					<xsl:value-of select="@label"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Title</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</dt>
		<dd>
			<xsl:apply-templates select="text() |* [not(self::unitdate)]"/>
		</dd>

		<!--If unitdate is a child of unittitle, it inserts unitdate on a new line.  -->
		<xsl:if test="child::unitdate">
			<!--The template tests to see if there is a label attribute for unittitle,
			inserting the contents if there is or adding one if there isn't. -->
			<dt>
				<xsl:choose>
					<xsl:when test="unitdate/@label">
						<xsl:value-of select="unitdate/@label"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Dates</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</dt>
			<dd>
				<xsl:apply-templates select="unitdate"/>
			</dd>
		</xsl:if>
	</xsl:template>
	<!-- Processes the unit date if it is not a child of unit title but a child of did, the current context.-->
	<xsl:template match="archdesc/did/unitdate">

		<!--The template tests to see if there is a label attribute for a unittitle that is the
		child of did and not unittitle, inserting the contents if there is or adding one if there isn't.-->
		<dt>
			<xsl:choose>
				<xsl:when test="@label">
					<xsl:value-of select="@label"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Dates:</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</dt>
		<dd>
			<xsl:apply-templates/>
		</dd>
	</xsl:template>



	<!--This template processes the note element.-->
	<xsl:template match="archdesc/did/note">
		<xsl:for-each select="p">
			<!--The template tests to see if there is a label attribute,
			inserting the contents if there is or adding one if there isn't. -->
				<dt>
					<xsl:if test="position()=1">
						<xsl:choose>
							<xsl:when test="parent::note[@label]">
								<xsl:value-of select="parent::note/@label"/>
							</xsl:when>
							<xsl:otherwise>Note</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</dt>
				<dl>
					<xsl:apply-templates/>
				</dl>
		</xsl:for-each>
	</xsl:template>

	<!--This template rule formats the top-level bioghist element and
      creates a link back to the top of the page after the display of the element.-->
	<xsl:template match="archdesc/bioghist |
      archdesc/scopecontent |
      archdesc/phystech |
      archdesc/odd   |
      archdesc/arrangement">
		<a name="{@id}"></a>
		<xsl:if test="string(child::*)">
			<xsl:apply-templates/>
			<hr/>
		</xsl:if>
	</xsl:template>

	<!--This template formats various head elements and makes them targets for
      links from the Table of Contents.-->
	<xsl:template
		match="archdesc/bioghist/head  |
      archdesc/scopecontent/head |
      archdesc/phystech/head |
      archdesc/controlaccess/head |
      archdesc/odd/head |
      archdesc/arrangement/head">
		<h3>
			<xsl:apply-templates/>
		</h3>
	</xsl:template>

	<xsl:template
		match="archdesc/bioghist/p |
      archdesc/scopecontent/p |
      archdesc/phystech/p |
      archdesc/controlaccess/p |
      archdesc/odd/p |
      archdesc/bioghist/note/p |
      archdesc/scopecontent/note/p |
      archdesc/phystech/note/p |
      archdesc/controlaccess/note/p |
      archdesc/odd/note/p">
		<p>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="archdesc/bioghist/bioghist/head |
      archdesc/scopecontent/scopecontent/head">
		<h3>
			<xsl:apply-templates/>
		</h3>
	</xsl:template>

	<xsl:template match="archdesc/bioghist/bioghist/p |
      archdesc/scopecontent/scopecontent/p |
      archdesc/bioghist/bioghist/note/p |
      archdesc/scopecontent/scopecontent/note/p">
		<p>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<!-- The next two templates format an arrangement
      statement embedded in <scopecontent>.-->

	<xsl:template match="archdesc/scopecontent/arrangement/head">
		<h4>
			<xsl:apply-templates/>
		</h4>
	</xsl:template>


	<xsl:template match="archdesc/scopecontent/arrangement/p
      | archdesc/scopecontent/arrangement/note/p">
		<p>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<!-- The next three templates format a list within an arrangement
      statement whether it is directly within <archdesc> or embedded in
      <scopecontent>.-->

	<xsl:template match="archdesc/scopecontent/arrangement/list/head">
		<div>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="archdesc/arrangement/list/head">
		<div>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="archdesc/scopecontent/arrangement/list/item
      | archdesc/arrangement/list/item">
		<div>
			<a>
				<xsl:attribute name="href">#series<xsl:number/>
				</xsl:attribute>
				<xsl:apply-templates/>
			</a>
		</div>
	</xsl:template>

   <!--This template rule formats the top-level related material
      elements by combining any related or separated materials
      elements. It begins by testing to see if there related or separated
      materials elements with content.-->
   <xsl:template name="archdesc-relatedmaterial">
      <xsl:if test="string(archdesc/relatedmaterial) or
         string(archdesc/*/relatedmaterial) or
string(archdesc/*/relatedmaterial/relatedmaterial)
or 
         string(archdesc/separatedmaterial) or
         string(archdesc/*/separatedmaterial)
or string(archdesc/*/separatedmaterial/separatedmaterial)">
         <h3>
            <a name="relatedmatlink">
               <b>
                  <xsl:text>Related Material</xsl:text>
               </b>
            </a>
         </h3>

<p>
         <xsl:apply-templates select="archdesc/relatedmaterial/p
            | archdesc/*/relatedmaterial/p
| archdesc/*/relatedmaterial/relatedmaterial/p

            | archdesc/relatedmaterial/note/p
            | archdesc/*/relatedmaterial/note/p
| archdesc/*/relatedmaterial/relatedmaterial/note/p

|archdesc/relatedmaterial/list/*
            | archdesc/*/relatedmaterial/list/*
| archdesc/*/relatedmaterial/relatedmaterial/list/*"/>
         </p>

<xsl:apply-templates select="archdesc/separatedmaterial/p
            | archdesc/*/separatedmaterial/p
| archdesc/*/separatedmaterial/separatedmaterial/p

            | archdesc/separatedmaterial/note/p
            | archdesc/*/separatedmaterial/note/p
| archdesc/*/separatedmaterial/separatedmaterial/note/p

| archdesc/separatedmaterial/list/*
            | archdesc/*/separatedmaterial/list/*
| archdesc/*/separatedmaterial/separatedmaterial/list/*"/>



         <hr></hr>
      </xsl:if>
   </xsl:template>
   
   <xsl:template match="archdesc/relatedmaterial/p
      | archdesc/*/relatedmaterial/p
| archdesc/*/relatedmaterial/relatedmaterial/p

      | archdesc/separatedmaterial/p
      | archdesc/*/separatedmaterial/p
| archdesc/*/separatedmaterial/separatedmaterial/p

      | archdesc/relatedmaterial/note/p
      | archdesc/*/relatedmaterial/note/p
| archdesc/*/relatedmaterial/relatedmaterial/note/p

      | archdesc/separatedmaterial/note/p
      | archdesc/*/separatedmaterial/note/p
	  | archdesc/*/separatedmaterial/separatedmaterial/note/p">

      <p>
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   
<!-- LISTS -->
   <!--This template rule formats a list element anywhere
      except in arrangement.-->
   <xsl:template match="list[parent::*[not(self::arrangement)]]/head">
      <div class="list_head">

         <xsl:attribute name="id">
            <!-- originally <xsl:text>series</xsl:text><xsl:number from="dsc" count="c01 "/> -->
            <xsl:value-of select="@id"/>
         </xsl:attribute>
         <b>
            <xsl:apply-templates/>
         </b>
      </div>
   </xsl:template>

   <xsl:template match="list[parent::*[not(self::arrangement)]]/defitem">
      <div class="deflist_top">
         <p>
            <xsl:apply-templates/>
         </p>
      </div>
   </xsl:template>

   <xsl:template match="list[parent::*[not(self::arrangement)]]/defitem/label">
      <div class="deflist_label">
         <xsl:apply-templates/>
         <br/>
      </div>
   </xsl:template>

   <xsl:template match="list[parent::*[not(self::arrangement)]]/defitem/item">
      <div class="deflist_item">
         <xsl:apply-templates/>
         <br/>
      </div>
   </xsl:template>

   <xsl:template match="list[parent::*[not(self::arrangement)]]/item">
      <div class="list_item">
         <xsl:apply-templates/>
         <br/>
      </div>
   </xsl:template>

   <xsl:template match="list[@type='marked']/item">
      <div class="marked_item">
         <xsl:text>&#8226;&#x20;&#x20;&#x20;</xsl:text>
         <xsl:apply-templates/>
         <br/>
      </div>
   </xsl:template>

   <!-- added from eadshared.xsl in NoteTabPro styles folder -->
   <xsl:template match="list[@type=&quot;ordered&quot;]">

      <span class="numberedindex">
         <xsl:element name="table">
            <xsl:call-template name="tableattrs"/>
            <xsl:if test="ancestor::list">
               <xsl:attribute name="style">margin-left:12px</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="head"/>
            <xsl:for-each select="item">
               <!-- node is item -->
               <xsl:element name="tr">
                  <xsl:element name="td">

                     <xsl:attribute name="valign">
                        <xsl:text>top</xsl:text>
                     </xsl:attribute>
                     <xsl:choose>
                        <xsl:when test="parent::list/@numeration">
                           <xsl:choose>
                              <xsl:when test="parent::list/@numeration=&quot;arabic&quot;">
                                 <xsl:number level="single" format="1."/>
                              </xsl:when>
                              <xsl:when test="parent::list/@numeration=&quot;upperalpha&quot;">
                                 <xsl:number level="single" format="A."/>
                              </xsl:when>
                              <xsl:when test="parent::list/@numeration=&quot;loweralpha&quot;">
                                 <xsl:number level="single" format="a."/>
                              </xsl:when>
                              <xsl:when test="parent::list/@numeration=&quot;upperroman&quot;">
                                 <xsl:number level="single" format="I."/>
                              </xsl:when>
                              <xsl:when test="parent::list/@numeration=&quot;lowerroman&quot;">
                                 <xsl:number level="single" format="i."/>
                              </xsl:when>
                              <xsl:otherwise> </xsl:otherwise>
                           </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:choose>
                              <!-- inner choose -->

                              <xsl:when
                                 test="parent::list/parent::item/parent::list/parent::item/parent::list[not(parent::item)]">
                                 <xsl:number level="single" format="1."/>
                              </xsl:when>
                              <xsl:when
                                 test="parent::list/parent::item/parent::list[not(parent::item)]">
                                 <xsl:number level="single" format="A."/>
                              </xsl:when>

                              <xsl:when test="parent::list[not(parent::item)]">
                                 <xsl:number level="single" format="I."/>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:message>
                                    <xsl:text>List nesting exceeds level tested for in</xsl:text>
                                    <xsl:text>stylesheet!!!</xsl:text>
                                 </xsl:message>
                              </xsl:otherwise>
                           </xsl:choose>
                           <!-- close inner choose -->
                        </xsl:otherwise>
                     </xsl:choose>
                     <xsl:text>&#160;</xsl:text>
                  </xsl:element>
                  <xsl:element name="td">
                     <xsl:attribute name="valign">
                        <xsl:text>top</xsl:text>
                     </xsl:attribute>
                     <xsl:apply-templates/>
                  </xsl:element>
               </xsl:element>
            </xsl:for-each>

         </xsl:element>
      </span>
   </xsl:template>

<!-- Table outline template -->
   <xsl:template name="tableattrs">
      <xsl:attribute name="border">
         <xsl:value-of select="$borderon"/>
      </xsl:attribute>
      <xsl:attribute name="cellspacing">1</xsl:attribute>
      <xsl:attribute name="cellpadding">1</xsl:attribute>
   </xsl:template>
 <!-- Variable to store the value of the border of declared tables-->
   <xsl:variable name="borderon">0</xsl:variable>

	<!--This template formats the top-level controlaccess element.
      It begins by testing to see if there is any controlled
      access element with content. It then invokes one of two templates
      for the children of controlaccess.  -->
	<xsl:template match="archdesc/controlaccess">
		<a name="{@id}"></a>
		<xsl:if test="string(child::*)">
			<xsl:apply-templates select="head"/>
			<p>
				<xsl:apply-templates select="p | note/p"/>
			</p>
			<ul>
				<xsl:for-each select="descendant::subject |descendant::corpname | descendant::famname | descendant::persname | descendant::genreform | descendant::title | descendant::geogname | descendant::occupation">
					<xsl:sort select="." data-type="text" order="ascending"/>
					<li>
						<a href="{$xtfURL}search?f1-{local-name()}={.}">
							<xsl:apply-templates/>
						</a>
					</li>
				</xsl:for-each>
			</ul>			
		</xsl:if>
	</xsl:template>


	<!--This template rule formats a top-level access and use retriction elements.
      They are displayed under a common heading.
      It begins by testing to see if there are any restriction elements with content.-->
	<xsl:template name="archdesc-restrict">
		<xsl:if test="string(archdesc/userestrict/*)
         or string(archdesc/accessrestrict/*)
         or string(archdesc/*/userestrict/*)
         or string(archdesc/*/accessrestrict/*)">
			<h3>
				<a name="restrictlink"/>
				<xsl:text>Restrictions</xsl:text>
			</h3>
			<xsl:apply-templates select="archdesc/accessrestrict
            | archdesc/*/accessrestrict"/>
			<xsl:apply-templates select="archdesc/userestrict
            | archdesc/*/userestrict"/>
			<hr/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="archdesc/accessrestrict/head
      | archdesc/userestrict/head
      | archdesc/*/accessrestrict/head
      | archdesc/*/userestrict/head">
		<h4>
			<xsl:apply-templates/>
		</h4>
	</xsl:template>

	<xsl:template
		match="archdesc/accessrestrict/p
      | archdesc/userestrict/p
      | archdesc/*/accessrestrict/p
      | archdesc/*/userestrict/p
      | archdesc/accessrestrict/note/p
      | archdesc/userestrict/note/p
      | archdesc/*/accessrestrict/note/p
      | archdesc/*/userestrict/note/p">
		<p style="margin-left:50pt">
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<!--This templates consolidates all the other administrative information
      elements into one block under a common heading.  It formats these elements
      regardless of which of three encodings has been utilized.  They may be
      children of archdesc, admininfo, or descgrp.
      It begins by testing to see if there are any elements of this type
      with content.-->

	<xsl:template name="archdesc-admininfo">
		<xsl:if
			test="string(archdesc/admininfo/custodhist/*)
         or string(archdesc/altformavail/*)
         or string(archdesc/prefercite/*)
         or string(archdesc/acqinfo/*)
         or string(archdesc/processinfo/*)
         or string(archdesc/appraisal/*)
         or string(archdesc/accruals/*)
         or string(archdesc/*/custodhist/*)
         or string(archdesc/*/altformavail/*)
         or string(archdesc/*/prefercite/*)
         or string(archdesc/*/acqinfo/*)
         or string(archdesc/*/processinfo/*)
         or string(archdesc/*/appraisal/*)
         or string(archdesc/*/accruals/*)">
			<h3>
				<a name="adminlink"/>
				<xsl:text>Administrative Information</xsl:text>
			</h3>
			<xsl:apply-templates select="archdesc/custodhist
            | archdesc/*/custodhist"/>
			<xsl:apply-templates select="archdesc/altformavail
            | archdesc/*/altformavail"/>
			<xsl:apply-templates select="archdesc/prefercite
            | archdesc/*/prefercite"/>
			<xsl:apply-templates select="archdesc/acqinfo
            | archdesc/*/acqinfo"/>
			<xsl:apply-templates select="archdesc/processinfo
            | archdesc/*/processinfo"/>
			<xsl:apply-templates select="archdesc/appraisal
            | archdesc/*/appraisal"/>
			<xsl:apply-templates select="archdesc/accruals
            | archdesc/*/accruals"/>
			<hr/>
		</xsl:if>
	</xsl:template>


	<!--This template rule formats the head element of top-level elements of
      administrative information.-->
	<xsl:template
		match="custodhist/head
      | archdesc/altformavail/head
      | archdesc/prefercite/head
      | archdesc/acqinfo/head
      | archdesc/processinfo/head
      | archdesc/appraisal/head
      | archdesc/accruals/head
      | archdesc/*/custodhist/head
      | archdesc/*/altformavail/head
      | archdesc/*/prefercite/head
      | archdesc/*/acqinfo/head
      | archdesc/*/processinfo/head
      | archdesc/*/appraisal/head
      | archdesc/*/accruals/head">
		<h4>
			<b>
				<xsl:apply-templates/>
			</b>
		</h4>
	</xsl:template>

	<xsl:template
		match="custodhist/p
      | archdesc/altformavail/p
      | archdesc/prefercite/p
      | archdesc/acqinfo/p
      | archdesc/processinfo/p
      | archdesc/appraisal/p
      | archdesc/accruals/p
      | archdesc/*/custodhist/p
      | archdesc/*/altformavail/p
      | archdesc/*/prefercite/p
      | archdesc/*/acqinfo/p
      | archdesc/*/processinfo/p
      | archdesc/*/appraisal/p
      | archdesc/*/accruals/p
      | archdesc/custodhist/note/p
      | archdesc/altformavail/note/p
      | archdesc/prefercite/note/p
      | archdesc/acqinfo/note/p
      | archdesc/processinfo/note/p
      | archdesc/appraisal/note/p
      | archdesc/accruals/note/p
      | archdesc/*/custodhist/note/p
      | archdesc/*/altformavail/note/p
      | archdesc/*/prefercite/note/p
      | archdesc/*/acqinfo/note/p
      | archdesc/*/processinfo/note/p
      | archdesc/*/appraisal/note/p
      | archdesc/*/accruals/note/p">

		<p>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="archdesc/otherfindaid
      | archdesc/*/otherfindaid
      | archdesc/bibliography
      | archdesc/*/bibliography
      | archdesc/phystech
      | archdesc/originalsloc">
		<xsl:apply-templates/>
		<hr/>
	</xsl:template>

	<xsl:template
		match="archdesc/otherfindaid/head
      | archdesc/*/otherfindaid/head
      | archdesc/bibliography/head
      | archdesc/*/bibliography/head
      | archdesc/fileplan/head
      | archdesc/*/fileplan/head
      | archdesc/phystech/head
      | archdesc/originalsloc/head">
		<h3>
			<b>
				<xsl:apply-templates/>
			</b>
		</h3>
	</xsl:template>

	<xsl:template
		match="archdesc/otherfindaid/p
      | archdesc/*/otherfindaid/p
      | archdesc/bibliography/p
      | archdesc/*/bibliography/p
      | archdesc/otherfindaid/note/p
      | archdesc/*/otherfindaid/note/p
      | archdesc/bibliography/note/p
      | archdesc/*/bibliography/note/p
      | archdesc/fileplan/p
      | archdesc/*/fileplan/p
      | archdesc/fileplan/note/p
      | archdesc/*/fileplan/note/p
      | archdesc/phystech/p
      | archdesc/phystechc/note/p
      | archdesc/originalsloc/p
      | archdesc/originalsloc/note/p">
		<p>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<!--This template rule tests for and formats the top-level index element. It begins
      by testing to see if there is an index element with content.-->
	<xsl:template match="archdesc/index
      | archdesc/*/index">
		<table width="100%">
			<tr>
				<td width="5%"> </td>
				<td width="45%"> </td>
				<td width="50%"> </td>
			</tr>
			<tr>
				<td colspan="3">
					<h3>
						<b>
							<xsl:apply-templates select="head"/>
						</b>
					</h3>
				</td>
			</tr>
			<xsl:for-each select="p | note/p">
				<tr>
					<td/>
					<td colspan="2">
						<xsl:apply-templates/>
					</td>
				</tr>
			</xsl:for-each>

			<!--Processes each index entry.-->
			<xsl:for-each select="indexentry">

				<!--Sorts each entry term.-->
				<xsl:sort select="corpname | famname | function | genreform | geogname | name | occupation | persname | subject"/>
				<tr>
					<td/>
					<td>
						<xsl:apply-templates select="corpname | famname | function | genreform | geogname | name | occupation | persname | subject"/>
					</td>
					<!--Supplies whitespace and punctuation if there is a pointer
                  group with multiple entries.-->

					<xsl:choose>
						<xsl:when test="ptrgrp">
							<td>
								<xsl:for-each select="ptrgrp">
									<xsl:for-each select="ref | ptr">
										<xsl:apply-templates/>
										<xsl:if test="preceding-sibling::ref or preceding-sibling::ptr">
											<xsl:text>, </xsl:text>
										</xsl:if>
									</xsl:for-each>
								</xsl:for-each>
							</td>
						</xsl:when>
						<!--If there is no pointer group, process each reference or pointer.-->
						<xsl:otherwise>
							<td>
								<xsl:for-each select="ref | ptr">
									<xsl:apply-templates/>
								</xsl:for-each>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<!--Closes the indexentry.-->
			</xsl:for-each>
		</table>
		<hr/>
	</xsl:template>

	<!--Insert the address for the dsc stylesheet of your choice here.-->
	<xsl:include href="dsc6.xsl"/>
</xsl:stylesheet>
