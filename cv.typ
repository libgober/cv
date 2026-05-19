
#import "cv_template.typ": *

// load the cv data
#let cv-data = yaml("content/cv.yaml")
// load bib data without printing
#show bibliography: none
#bibliography("content/publications.bib")

// define some convenient variables for accessing cv data
#let advising = cv-data.advising
#let appointments = cv-data.appointments
#let education = cv-data.education
#let grants = cv-data.grants
#let peer_review = cv-data.peer_review
#let presentations = cv-data.presentations
#let publications = cv-data.publications
#let service = cv-data. service
#let teaching = cv-data.teaching

#show: cv

#cv-header(
  name: "Brian Libgober",
  l: [
    Department of Political Science \
    Northwestern University
  ],
  r: [
    #link("mailto:brian.libgober\@northwestern.edu")[brian.libgober\@northwestern.edu] \
    #link("https://brianlibgober.com")[brianlibgober.com] \
    +1 708 642 4741
  ],
)

= Education

#for item in education {
  render-education-item(item)
}

= Appointments

#for item in appointments {
  render-appointment-item(item)
}

= Research Interests

    American Politics, Political Institutions, Executive Branch Politics, Lobbying, Special Interests,  Political Economy, Public Policy, Law and Politics
    
= Publications

== Book Project

#emph[White Shoes, Hidden Hands: Lawyers, Lobbying, and the Administrative State]. 

== Articles in Peer-Reviewed Journals

#set enum(reversed: true)

#for item in publications.peer {
   enum.item()[#render-peer-pub-item(item)  #v(0.5em)]
 
}

== Other Publications

#for item in publications.other {
  [#render-peer-pub-item(item)]
} 


#set footnote(numbering: "*")

== Working Papers #footnote[Current links to all working papers available on author's website]

#for item in publications.working{
  render_working_paper(item)
}

= Grants, Fellowships, and Awards

== External Grants and Fellowships

#for item in grants {
  if item.source == "external" {
   render-award(item)  
  }
}


== Internal Grants and Research Support

#for item in grants {
  if item.source == "internal" {
   render-award(item)  
  }
}

== Awards

#block(below: 1em, breakable: false)[
  #grid( 
      columns: (3em, 1fr),
      column-gutter: 0.9em,
      align(left)[2023],
      [Emerging Scholar in American Political Economy, American Political Science Association.]
    )
  ]
  
= Presentations and Conferences

== Invited Lectures

#for item in presentations.presentations {
  render_talk(item)
}

== Conference Presentations

#for item in presentations.conferences  {
  render_talk(item)
}

== Workshop Participation

#for item in presentations.workshops {
  render_talk(item)
}

== Conference and Workshop Organizing

#for item in presentations.organizing {
  render_talk(item)
}

== Other Conference Participation

#for item in presentations.other {
  render_talk(item)
}

== Departmental Talks

#for item in presentations.department {
  render_talk(item)
}

= Advising

== Graduate Advising

=== Dissertation Committees


#for item in advising.graduate.former_committees {
  render-former-committee(item)
}

\

=== Current Students
  
#for item in advising.graduate.current_committees {
  render-current-committee(item)
}


== Undergraduate Advising

=== Honors Theses

#for item in advising.undergraduate.theses {
  render-undergrad-item(item)
}


=== Research Assistants

#for item in advising.undergraduate.ras {
  render-undergrad-item(item)
}

=== Reading Courses

#for item in advising.undergraduate.courses {
  render-undergrad-item(item)
}


= Teaching

#for group in teaching {
  heading(level: 2)[#group.institution]

  for course in group.courses {
    render-course(course)
  }
}

= Service

== Service to the Field


#for item in service.field {
  render-service-item(item)
}

== Departmental Service

#for group in service.departmental {
  heading(level: 3)[#group.institution]

  for item in group.items {
    render-service-item(item)
  }
}


== Academic Peer Review

#peer_review.map(x => emph(x)).join[, ].


//= Memberships

//= Prior Work Experience

