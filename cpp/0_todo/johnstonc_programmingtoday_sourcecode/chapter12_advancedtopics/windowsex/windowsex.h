// WindowsEx.h : main header file for the WINDOWSEX application
//

#if !defined(AFX_WINDOWSEX_H__53BBD904_75E4_11D4_803D_00A0CC5774AA__INCLUDED_)
#define AFX_WINDOWSEX_H__53BBD904_75E4_11D4_803D_00A0CC5774AA__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"       // main symbols

/////////////////////////////////////////////////////////////////////////////
// CWindowsExApp:
// See WindowsEx.cpp for the implementation of this class
//

class CWindowsExApp : public CWinApp
{
public:
	CWindowsExApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CWindowsExApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation
	//{{AFX_MSG(CWindowsExApp)
	afx_msg void OnAppAbout();
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_WINDOWSEX_H__53BBD904_75E4_11D4_803D_00A0CC5774AA__INCLUDED_)
