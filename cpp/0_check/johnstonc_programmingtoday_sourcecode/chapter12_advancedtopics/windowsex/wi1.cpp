// WindowsExDoc.cpp : implementation of the CWindowsExDoc class
//

#include "stdafx.h"
#include "WindowsEx.h"

#include "WindowsExDoc.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CWindowsExDoc

IMPLEMENT_DYNCREATE(CWindowsExDoc, CDocument)

BEGIN_MESSAGE_MAP(CWindowsExDoc, CDocument)
	//{{AFX_MSG_MAP(CWindowsExDoc)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CWindowsExDoc construction/destruction

CWindowsExDoc::CWindowsExDoc()
{
	// TODO: add one-time construction code here

}

CWindowsExDoc::~CWindowsExDoc()
{
}

BOOL CWindowsExDoc::OnNewDocument()
{
	if (!CDocument::OnNewDocument())
		return FALSE;

	// TODO: add reinitialization code here
	// (SDI documents will reuse this document)

	return TRUE;
}



/////////////////////////////////////////////////////////////////////////////
// CWindowsExDoc serialization

void CWindowsExDoc::Serialize(CArchive& ar)
{
	if (ar.IsStoring())
	{
		// TODO: add storing code here
	}
	else
	{
		// TODO: add loading code here
	}
}

/////////////////////////////////////////////////////////////////////////////
// CWindowsExDoc diagnostics

#ifdef _DEBUG
void CWindowsExDoc::AssertValid() const
{
	CDocument::AssertValid();
}

void CWindowsExDoc::Dump(CDumpContext& dc) const
{
	CDocument::Dump(dc);
}
#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CWindowsExDoc commands
