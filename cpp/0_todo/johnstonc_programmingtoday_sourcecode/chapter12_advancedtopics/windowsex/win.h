// WindowsExView.h : interface of the CWindowsExView class
//
/////////////////////////////////////////////////////////////////////////////

#if !defined(AFX_WINDOWSEXVIEW_H__53BBD90C_75E4_11D4_803D_00A0CC5774AA__INCLUDED_)
#define AFX_WINDOWSEXVIEW_H__53BBD90C_75E4_11D4_803D_00A0CC5774AA__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


class CWindowsExView : public CView
{
protected: // create from serialization only
	CWindowsExView();
	DECLARE_DYNCREATE(CWindowsExView)

// Attributes
public:
	CWindowsExDoc* GetDocument();

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CWindowsExView)
	public:
	virtual void OnDraw(CDC* pDC);  // overridden to draw this view
	virtual BOOL PreCreateWindow(CREATESTRUCT& cs);
	protected:
	virtual BOOL OnPreparePrinting(CPrintInfo* pInfo);
	virtual void OnBeginPrinting(CDC* pDC, CPrintInfo* pInfo);
	virtual void OnEndPrinting(CDC* pDC, CPrintInfo* pInfo);
	//}}AFX_VIRTUAL

// Implementation
public:
	virtual ~CWindowsExView();
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

protected:

// Generated message map functions
protected:
	//{{AFX_MSG(CWindowsExView)
	afx_msg void OnLButtonDown(UINT nFlags, CPoint point);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

#ifndef _DEBUG  // debug version in WindowsExView.cpp
inline CWindowsExDoc* CWindowsExView::GetDocument()
   { return (CWindowsExDoc*)m_pDocument; }
#endif

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_WINDOWSEXVIEW_H__53BBD90C_75E4_11D4_803D_00A0CC5774AA__INCLUDED_)
