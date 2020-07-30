// WindowsExView.cpp : implementation of the CWindowsExView class
//

#include "stdafx.h"
#include "WindowsEx.h"

#include "WindowsExDoc.h"
#include "WindowsExView.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CWindowsExView

IMPLEMENT_DYNCREATE(CWindowsExView, CView)

BEGIN_MESSAGE_MAP(CWindowsExView, CView)
	//{{AFX_MSG_MAP(CWindowsExView)
	ON_WM_LBUTTONDOWN()
	//}}AFX_MSG_MAP
	// Standard printing commands
	ON_COMMAND(ID_FILE_PRINT, CView::OnFilePrint)
	ON_COMMAND(ID_FILE_PRINT_DIRECT, CView::OnFilePrint)
	ON_COMMAND(ID_FILE_PRINT_PREVIEW, CView::OnFilePrintPreview)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CWindowsExView construction/destruction

CWindowsExView::CWindowsExView()
{
	// TODO: add construction code here

}

CWindowsExView::~CWindowsExView()
{
}

BOOL CWindowsExView::PreCreateWindow(CREATESTRUCT& cs)
{
	// TODO: Modify the Window class or styles here by modifying
	//  the CREATESTRUCT cs

	return CView::PreCreateWindow(cs);
}

/////////////////////////////////////////////////////////////////////////////
// CWindowsExView drawing

void CWindowsExView::OnDraw(CDC* pDC)
{
	CWindowsExDoc* pDoc = GetDocument();
	ASSERT_VALID(pDoc);
	// TODO: add draw code for native data here
}

/////////////////////////////////////////////////////////////////////////////
// CWindowsExView printing

BOOL CWindowsExView::OnPreparePrinting(CPrintInfo* pInfo)
{
	// default preparation
	return DoPreparePrinting(pInfo);
}

void CWindowsExView::OnBeginPrinting(CDC* /*pDC*/, CPrintInfo* /*pInfo*/)
{
	// TODO: add extra initialization before printing
}

void CWindowsExView::OnEndPrinting(CDC* /*pDC*/, CPrintInfo* /*pInfo*/)
{
	// TODO: add cleanup after printing
}

/////////////////////////////////////////////////////////////////////////////
// CWindowsExView diagnostics

#ifdef _DEBUG
void CWindowsExView::AssertValid() const
{
	CView::AssertValid();
}

void CWindowsExView::Dump(CDumpContext& dc) const
{
	CView::Dump(dc);
}

CWindowsExDoc* CWindowsExView::GetDocument() // non-debug version is inline
{
	ASSERT(m_pDocument->IsKindOf(RUNTIME_CLASS(CWindowsExDoc)));
	return (CWindowsExDoc*)m_pDocument;
}
#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CWindowsExView message handlers

void CWindowsExView::OnLButtonDown(UINT nFlags, CPoint point) 
{
	// TODO: Add your message handler code here and/or call default
	MessageBeep(MB_OK);
	
	CView::OnLButtonDown(nFlags, point);
}
