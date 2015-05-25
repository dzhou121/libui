// 11 april 2015
#include "uipriv_windows.h"

struct label {
	uiLabel l;
	HWND hwnd;
};

static void onDestroy(void *data)
{
	struct label *l = (struct label *) data;

	uiFree(l);
}

// via http://msdn.microsoft.com/en-us/library/windows/desktop/dn742486.aspx#sizingandspacing
#define labelHeight 8

static void labelPreferredSize(uiControl *c, uiSizing *d, intmax_t *width, intmax_t *height)
{
	struct label *l = (struct label *) c;

	*width = uiWindowsWindowTextWidth(l->hwnd);
	*height = uiWindowsDlgUnitsToY(labelHeight, d->Sys->BaseY);
}

static char *labelText(uiLabel *l)
{
	return uiWindowsControlText(uiControl(l));
}

static void labelSetText(uiLabel *l, const char *text)
{
	uiWindowsControlSetText(uiControl(l), text);
}

uiLabel *uiNewLabel(const char *text)
{
	struct label *l;
	uiWindowsMakeControlParams p;
	WCHAR *wtext;

	l = uiNew(struct label);
	uiTyped(l)->Type = uiTypeLabel();

	p.dwExStyle = 0;
	p.lpClassName = L"static";
	wtext = toUTF16(text);
	p.lpWindowName = wtext;
	// SS_LEFTNOWORDWRAP clips text past the end; SS_NOPREFIX avoids accelerator translation
	// controls are vertically aligned to the top by default (thanks Xeek in irc.freenode.net/#winapi)
	p.dwStyle = SS_LEFTNOWORDWRAP | SS_NOPREFIX;
	p.hInstance = hInstance;
	p.lpParam = NULL;
	p.useStandardControlFont = TRUE;
	p.onDestroy = onDestroy;
	p.onDestroyData = l;
	uiWindowsMakeControl(uiControl(l), &p);
	uiFree(wtext);

	l->hwnd = (HWND) uiControlHandle(uiControl(l));

	uiControl(l)->PreferredSize = labelPreferredSize;

	uiLabel(l)->Text = labelText;
	uiLabel(l)->SetText = labelSetText;

	return uiLabel(l);
}