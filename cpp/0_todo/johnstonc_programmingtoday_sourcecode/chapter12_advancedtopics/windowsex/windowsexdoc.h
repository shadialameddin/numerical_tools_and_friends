// WindowsExDoc.h : interface of the CWindowsExDoc class
//
/////////////////////////////////////////////////////////////////////////////

#if !defined(AFX_WINDOWSEXDOC_H__53BBD90A_75E4_11D4_803D_00A0CC5774AA__INCLUDED_)
#define AFX_WINDOWSEXDOC_H__53BBD90A_75E4_11D4_803D_00A0CC5774AA__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


class CWindowsExDoc : public CDocument
{
protected: // create from serialization only
	CWindowsExDoc();
	DECLARE_DYNCREATE(CWindowsExDoc)

// Attributes
public:

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CWindowsExDoc)
	public:
	virtual BOOL OnNewDocument();
	virtual void Serialize(CArchive& ar);
	//}}AFX_VIRTUAL

// Implementation
public:
	virtual ~CWindowsExDoc();
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

protected:

// Generated message map functions
protected:
	//{{AFX_MSG(CWindowsExDoc)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_WINDOWSEXDOC_H__53BBD90A_75E4_11D4_803D_00A0CC5774AA__INCLUDED_)
