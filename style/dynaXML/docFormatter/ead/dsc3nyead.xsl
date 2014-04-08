
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xtf="http://cdlib.org/xtf"
	xmlns="http://www.w3.org/1999/xhtml" version="1.0">

	<!-- This stylesheet formats the dsc where
	components have a single container element.-->
	<!--It assumes that c01 is a high-level description such as
	a series, subseries, subgroup or subcollection and does not have
	container elements associated with it.-->
	<!--Column headings for containers are inserted whenever
	the value of a container's type attribute differs from that of
	the container in the preceding component. -->
	<!-- The value of a column heading is taken from the type
    attribute of the container element.-->
	<!--The content of container elements is always displayed.-->
	<!-- c02 as subseries altered to provide anchor names when the info has been omitted -->


	<!-- .................Section 1.................. -->
	<!-- line break template -->

	<xsl:template match="lb">
		<br/>
	</xsl:template>
	
	<!-- blockquote template -->
	
	<xsl:template match="blockquote">
		<p style="margin-left:1em">
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<!--This section of the stylesheet formats dsc and
any introductory paragraphs.-->

	<xsl:template match="archdesc/dsc">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="dsc/head">
		<a name="{../@id}"/>
		<h3><xsl:apply-templates/></h3>
	</xsl:template>

	<xsl:template match="dsc/p | dsc/note/p">
		<p>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

<!-- not for use in NYEAD at this time 
	<xsl:template name="did-dao">
		<xsl:element name="a">
			<xsl:attribute name="href">
				<xsl:value-of select="did/dao/@href"/>
			</xsl:attribute>
			<xsl:attribute name="target">
				<xsl:text>_blank</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates select="archdesc/dsc//did/dao"/>
			<img src="../xtf/icons/default/camicon.gif" border="0" alt="icon"/>
		</xsl:element>
	</xsl:template> -->

	<xsl:template match="dsc//unittitle/unitdate">
		<span class="clist_unitdate">
			<xsl:apply-templates/>
		</span>
	</xsl:template>


	<!-- will  create separate line for work number when it is stated within a unittitle, followed by a title. 
		It may need to be rewritten to apply only to num as the first element within unittitle -->

	<xsl:template match="unittitle/num">
		<xsl:if test="following-sibling::title">
			<span class="worknumber">
				<xsl:apply-templates/>
				<br/>
			</span>
		</xsl:if>
	</xsl:template>

	<!-- will  add a class for persname and a line break between personal name and title in unittitle -->

	<xsl:template match="unittitle/persname">
		<xsl:choose>
			<xsl:when test="following-sibling::persname[last()=1]">
				<span class="unittitlepersname">
					<xsl:apply-templates/>
				</span>
			</xsl:when>


			<xsl:when test="following-sibling::title[1]">
				<span class="unittitlepersname">
					<xsl:apply-templates/>
				</span>
				<br/>
			</xsl:when>
			<xsl:otherwise>
				<span class="unittitlepersname">
					<xsl:apply-templates/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- will differentiate titles by type -->

	<xsl:template match="dsc//title">
		<xsl:choose>
			<xsl:when test="@type='uniform'">
				<span class="uniformtitle">
					<xsl:text>Uniform title: </xsl:text>
					<xsl:apply-templates/>
				</span>
				<br/>
			</xsl:when>

			<xsl:when test="@type='transcribed'">
				<span class="transcribedtitle">
					<xsl:apply-templates/>
				</span>
				<br/>
			</xsl:when>

			<xsl:when test="@type='journal' or @type='book' or @render='italic'">
				<span class="italicstitle">
					<xsl:apply-templates/>
				</span>
			</xsl:when>

			<xsl:when test="@type='review' or @type='course' or @type='article' or @type='chapter'">
				<span class="quotestitle">
					<xsl:text>&#x201C;</xsl:text>
					<xsl:apply-templates/>
					<xsl:text>&#x201D;</xsl:text>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<span class="titlenotype">
					<xsl:apply-templates/>
				</span>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<!-- ................Section 2 ...........................-->
	<!--This section of the stylesheet contains two templates
that are used generically throughout the stylesheet.-->

	<!--This template formats the unitid, origination, unittitle,
	unitdate, and physdesc elements of components at all levels.  They appear on
	a separate line from other did elements. It is generic to all
	component levels.-->

	<xsl:template name="component-did">
		<!--Inserts unitid and a space if it exists in the markup.-->

		<xsl:if test="unitid">
			<xsl:apply-templates select="unitid"/>
			<xsl:text>&#160;</xsl:text>
		</xsl:if>

		<!--This choose statement selects between cases where unitdate is a child of
		unittitle and where it is a separate child of did.-->
		<xsl:choose>
			<!--This code processes the elements when unitdate is a child
			of unittitle.-->
			<xsl:when test="unitdate">
				<xsl:apply-templates select="unittitle"/>
				<xsl:choose>
					<xsl:when test="ends-with(normalize-space(unittitle), ',')">
						<xsl:text>&#160;</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>,&#160;</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:for-each select="unitdate">
					<xsl:apply-templates/>
					<xsl:if test="following-sibling::unitdate">
						<xsl:choose>
							<xsl:when test="ends-with(normalize-space(unitdate), ',')"><xsl:text>&#x20;</xsl:text></xsl:when>
							<xsl:otherwise><xsl:text>,&#x20;</xsl:text></xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>

			<!--This code process the elements when unitdate is not a
					child of untititle-->
			<xsl:otherwise>
				<xsl:for-each select="unittitle">
					<xsl:apply-templates/>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<!-- ...............Section 3.............................. -->
	<!--This section of the stylesheet creates an HTML table for each c01.
It then recursively processes each child component of the
c01 by calling a named template specific to that component level.
The named templates are in section 4.-->

	<xsl:template match="c01|c">
		<xsl:for-each select=".">
			<xsl:choose>
				<xsl:when test="@level='subseries' or @level='series' or @level='subgrp'">
					<div class="row">
						<xsl:call-template name="c01-level"/>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<div class="row">
						<xsl:call-template name="c02-level-container"/>
					</div>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:for-each select="c02|c">
				<xsl:choose>
					<xsl:when test="@level='subseries' or @level='series' or @level='subgrp'">
						<div class="row">
							<xsl:call-template name="c02-level-subseries"/>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<div class="row">
							<xsl:call-template name="c02-level-container"/>
						</div>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:for-each select="c03|c">
					<xsl:choose>
						<xsl:when test="@level='subseries' or @level='series' or @level='subgrp'">
							<xsl:call-template name="c02-level-subseries"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="c02-level-container"/>
						</xsl:otherwise>
					</xsl:choose>

					<xsl:for-each select="c04|c">
						<xsl:choose>
							<xsl:when
								test="@level='subseries' or @level='series' or @level='subgrp'">
								<xsl:call-template name="c02-level-subseries"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="c02-level-container"/>
							</xsl:otherwise>
						</xsl:choose>

						<xsl:for-each select="c05|c">
							<xsl:call-template name="c02-level-container"/>

							<xsl:for-each select="c06|c">
								<xsl:call-template name="c02-level-container"/>

								<xsl:for-each select="c07|c">
									<xsl:call-template name="c02-level-container"/>

									<xsl:for-each select="c08|c">
										<xsl:call-template name="c02-level-container"/>

										<xsl:for-each select="c09|c">
											<xsl:call-template name="c02-level-container"/>

											<xsl:for-each select="c10|c">
												<xsl:call-template name="c02-level-container"/>
											</xsl:for-each>
											<!--Closes c10-->
										</xsl:for-each>
										<!--Closes c09-->
									</xsl:for-each>
									<!--Closes c08-->
								</xsl:for-each>
								<!--Closes c07-->
							</xsl:for-each>
							<!--Closes c06-->
						</xsl:for-each>
						<!--Closes c05-->
					</xsl:for-each>
					<!--Closes c04-->
				</xsl:for-each>
				<!--Closes c03-->
			</xsl:for-each>
			<!--Closes c02-->
		</xsl:for-each>
		<!--Closes c01-->
	</xsl:template>

	<!-- ...............Section 4.............................. -->
	<!--This section of the stylesheet contains a separate named template for
each component level.  The contents of each is identical except for the
spacing that is inserted to create the proper column display in HTML
for each level.-->

	<!--Processes c01 which is assumed to be a series
	description without associated components.-->
	<xsl:template name="c01-level">
		<xsl:for-each select="did">
			<a>
				<xsl:attribute name="name">
					<xsl:value-of select="../@id"/>
				</xsl:attribute>
			</a>
			<xsl:if test="unitid/@id">
				<a>
					<xsl:attribute name="name">
						<xsl:value-of select="unitid/@id"/>
					</xsl:attribute>
				</a>
			</xsl:if>
				<div class="col-md-12">
					<h4><xsl:call-template name="component-did"/></h4>
				</div>
				<xsl:for-each select="physdesc | physloc| origination | note/p | langmaterial | materialspec">
					<div class="col-md-12">
						<xsl:apply-templates/>
					</div>
				</xsl:for-each>
			
		</xsl:for-each>
		<!--Closes the did.-->

		<!--This template creates a separate row for each child of
		the listed elements. Do we need HEADS for these components? -->
		<xsl:for-each
			select="scopecontent | bioghist | arrangement 
		| userestrict | accessrestrict | processinfo |
		acqinfo | custodhist | controlaccess/controlaccess | odd | note
		| descgrp/*">
			<!--The head element is rendered in bold.-->
			<div class="col-md-12">
			<xsl:for-each select="head">
				<h5><xsl:apply-templates/></h5>
			</xsl:for-each>
			<xsl:for-each select="*[not(self::head)]">
				<xsl:apply-templates/>
			</xsl:for-each>
			</div>
		</xsl:for-each>

	</xsl:template>

	<!--This template processes c02 elements that have associated containers, for
	example when c02 is a file.-->
	<xsl:template name="c02-level-container">
		<xsl:for-each select="did">
			<xsl:if test="not(container/@type=preceding::did[1]/container/@type)">
				<div class="bg-primary col-md-12">
					<div class="col-md-1">
						<xsl:value-of
							select="concat(translate(substring(container[1]/@type, 1, 1),
							'abcdefghijklmnopqrstuvwxyz',
							'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
							), substring(container[1]/@type, 2))"
						/>
					</div>
					<div class="col-md-1">
						<xsl:value-of
							select="concat(translate(substring(container[2]/@type, 1, 1),
							'abcdefghijklmnopqrstuvwxyz',
							'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
							), substring(container[2]/@type, 2))"
						/>
					</div>
					<div class="col-md-10">
						<xsl:text>Contents</xsl:text>
					</div>
				</div>
			</xsl:if>
			<div class="col-md-12">
				<div class="col-md-1">
					<xsl:value-of select="container[1]"/>
				</div>
				<div class="col-md-1">
					<xsl:value-of select="container[2]"/>
				</div>
				<div class="col-md-10">
					<xsl:call-template name="component-did"/>
				</div>

				<xsl:for-each
					select="physdesc | physloc| origination | abstract | note/p | langmaterial | materialspec">
					<div class="col-md-10 col-md-offset-2 text-muted">
						<xsl:apply-templates/>
					</div>
				</xsl:for-each>
			</div>
		</xsl:for-each>
		<!--Closes the did.-->
		
		<div class="col-md-12">
			<xsl:for-each
				select="scopecontent | bioghist | arrangement |
			userestrict | accessrestrict | processinfo |
			acqinfo | custodhist | controlaccess/controlaccess | odd | note | descgrp/*">
				<div class="col-md-10 col-md-offset-2 text-muted">
					<xsl:apply-templates/>
					<!--<xsl:for-each select="head">
						<h5>
							<xsl:apply-templates/>
						</h5>
					</xsl:for-each>
					<xsl:for-each select="*[not(self::head)]">
						<xsl:apply-templates/>
					</xsl:for-each>-->
				</div>
			</xsl:for-each>
		</div>
	</xsl:template>

	<!--This template processes c02 level components that do not have
	associated containers, for example if the c02 is a subseries.-->


	<xsl:template name="c02-level-subseries">
		<xsl:for-each select="did">
			<a>
				<xsl:attribute name="name">
					<xsl:value-of select="../@id"/>
				</xsl:attribute>
			</a>
			<xsl:if test="unitid/@id">
				<a>
					<xsl:attribute name="name">
						<xsl:value-of select="unitid/@id"/>
					</xsl:attribute>
				</a>
			</xsl:if>
			<div class="col-md-12">
				<h4>
					<xsl:call-template name="component-did"/>
				</h4>
			</div>
			<xsl:for-each
				select="physdesc | physloc| origination | note/p | langmaterial | materialspec">
				<div class="col-md-12">
					<xsl:apply-templates/>
				</div>
			</xsl:for-each>
		</xsl:for-each>
		<!--Closes the did.-->

		<!--This template creates a separate row for each child of
				the listed elements. Do we need HEADS for these components? -->
		<xsl:for-each
			select="scopecontent | bioghist | arrangement 
				| userestrict | accessrestrict | processinfo |
				acqinfo | custodhist | controlaccess/controlaccess | odd | note
				| descgrp/*">
			<div class="col-md-12">
				<xsl:for-each select="head">
					<h5>
						<xsl:apply-templates/>
					</h5>
				</xsl:for-each>
				<xsl:for-each select="*[not(self::head)]">
					<xsl:apply-templates/>
				</xsl:for-each>
			</div>
		</xsl:for-each>

	</xsl:template>

</xsl:stylesheet>