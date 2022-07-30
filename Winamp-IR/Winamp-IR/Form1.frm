VERSION 5.00
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "MSCOMM32.OCX"
Begin VB.Form Form1 
   Caption         =   "Winamp IR Receiver Module v0.1"
   ClientHeight    =   1575
   ClientLeft      =   165
   ClientTop       =   735
   ClientWidth     =   5655
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   1575
   ScaleWidth      =   5655
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Exitbttn 
      Caption         =   "Exit"
      Height          =   375
      Left            =   3960
      TabIndex        =   4
      Top             =   1080
      Width           =   1575
   End
   Begin VB.CommandButton Clearbttn 
      Caption         =   "Clear Log"
      Height          =   375
      Left            =   3960
      TabIndex        =   3
      Top             =   720
      Width           =   1575
   End
   Begin VB.CommandButton Hidebttn 
      Caption         =   "Hide Module"
      Height          =   375
      Left            =   3960
      TabIndex        =   2
      Top             =   360
      Width           =   1575
   End
   Begin VB.CommandButton OnOffbttn 
      Caption         =   " Disable"
      Height          =   375
      Left            =   3960
      TabIndex        =   1
      Top             =   0
      Width           =   1575
   End
   Begin VB.TextBox StatusLog 
      BackColor       =   &H00000000&
      ForeColor       =   &H000080FF&
      Height          =   1455
      Left            =   120
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   0
      Top             =   0
      Width           =   3735
   End
   Begin VB.Timer Timer1 
      Interval        =   10
      Left            =   3600
      Top             =   480
   End
   Begin MSCommLib.MSComm MSComm1 
      Left            =   3600
      Top             =   840
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
      DTREnable       =   -1  'True
   End
   Begin VB.Menu Exitmenu 
      Caption         =   "Exit"
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Declare Sub keybd_event Lib "user32" ( _
    ByVal bVk As Byte, _
    ByVal bScan As Byte, _
    ByVal dwFlags As Long, _
    ByVal dwExtraInfo As Long _
)

Private Const VK_CONTROL = &H11             'Winamp Global Hotkeys.
Private Const VK_ALT = &H12
Private Const KEYEVENTF_KEYUP = &H2
Private Const VK_INS = &H2D
Private Const VK_END = &H23
Private Const VK_HOME = &H24
Private Const VK_PGUP = &H21
Private Const VK_PGDOWN = &H22
Private Const VK_UP = &H26
Private Const VK_DOWN = &H28
Private Const VK_LEFT = &H25
Private Const VK_RIGHT = &H27

Private Type NOTIFYICONDATA                 'Minimize to System Tray Codes are adopted
   cbSize As Long                           'and modified from RhinoBull from the
   hWnd As Long                             'Netherlands, at vbforums.com
   uid As Long
   uFlags As Long
   uCallBackMessage As Long
   hIcon As Long
   szTip As String * 64
End Type
Private NID As NOTIFYICONDATA

Private Const NIM_ADD = &H0
Private Const NIM_MODIFY = &H1
Private Const NIM_DELETE = &H2
Private Const WM_MOUSEMOVE = &H200
Private Const NIF_MESSAGE = &H1
Private Const NIF_ICON = &H2
Private Const NIF_TIP = &H4

Private Const WM_LBUTTONDBLCLK = &H203
Private Const WM_LBUTTONDOWN = &H201
Private Const WM_LBUTTONUP = &H202
Private Const WM_RBUTTONDBLCLK = &H206
Private Const WM_RBUTTONDOWN = &H204
Private Const WM_RBUTTONUP = &H205

Private Declare Function Shell_NotifyIcon Lib "shell32" Alias "Shell_NotifyIconA" _
                    (ByVal dwMessage As Long, pnid As NOTIFYICONDATA) As Boolean

Dim ASCIIdata() As Byte

Private Sub Clearbttn_Click()
StatusLog.Text = ""
End Sub

Private Sub Exitbttn_Click()
End
End Sub

Private Sub Exitmenu_Click()
End
End Sub

Private Sub Hidebttn_Click()
Me.WindowState = vbMinimized
End Sub

Private Sub OnOffbttn_Click()

If MSComm1.PortOpen = True Then
MSComm1.PortOpen = False
StatusLog.SelText = vbCrLf & "IR Receiver disconnected."
OnOffbttn.Caption = "Enable"
Else
MSComm1.PortOpen = True
StatusLog.SelText = vbCrLf & "IR Receiver ready and enabled."
OnOffbttn.Caption = "Disable"
End If

End Sub

Private Sub Form_Resize()

    If Me.WindowState = vbMinimized Then
        Me.Hide
        NID.cbSize = Len(NID)
        NID.hWnd = Me.hWnd
        NID.uid = vbNull
        NID.uFlags = NIF_ICON Or NIF_TIP Or NIF_MESSAGE
        NID.uCallBackMessage = WM_MOUSEMOVE
        NID.hIcon = Me.Icon
        NID.szTip = "Double Click to Restore Me! :)" & vbNullChar
        Shell_NotifyIcon NIM_ADD, NID
    End If

End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    Shell_NotifyIcon NIM_DELETE, NID
End Sub

Private Sub Form_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
Dim msg As Long

    msg = X / Screen.TwipsPerPixelX
    Select Case msg
        Case WM_LBUTTONDOWN
            
        Case WM_LBUTTONUP

        Case WM_LBUTTONDBLCLK
                Me.WindowState = vbNormal           'Restores application
                Me.Visible = True
                Shell_NotifyIcon NIM_DELETE, NID
        Case WM_RBUTTONDOWN
            
        Case WM_RBUTTONUP

        Case WM_RBUTTONDBLCLK

    End Select

End Sub

Private Sub Form_Load()

MSComm1.CommPort = 1                    'Define usage of COM1.
MSComm1.Settings = "1200, N, 8, 1"      '1200 Baudrate, No Parity, 8 bits data, 1 Stopbit.
MSComm1.InputLen = 1                    'Read 1 character/byte whenever Input property is used.
MSComm1.InputMode = comInputModeBinary  'Input will retrieve data in array of bytes.
MSComm1.PortOpen = True                 'Open Serial Port COM1.

Shell "C:\Program Files\Winamp\winamp.exe", vbNormalFocus
StatusLog.SelText = "IR Receiver ready and enabled."

End Sub

Private Sub Timer1_Timer()

If MSComm1.InBufferCount Then
    ASCIIdata() = MSComm1.Input
    
    Select Case ASCIIdata(0)
    Case &H30
        keybd_event VK_CONTROL, 0, 0, 0                 'press keys
        keybd_event VK_ALT, 0, 0, 0
        keybd_event VK_INS, 0, 0, 0

        StatusLog.SelText = vbCrLf & "0x30 Received, Play."

        keybd_event VK_CONTROL, 0, KEYEVENTF_KEYUP, 0   'release keys
        keybd_event VK_ALT, 0, KEYEVENTF_KEYUP, 0
        keybd_event VK_INS, 0, KEYEVENTF_KEYUP, 0
        
    Case &H31
        keybd_event VK_CONTROL, 0, 0, 0                 'press keys
        keybd_event VK_ALT, 0, 0, 0
        keybd_event VK_HOME, 0, 0, 0

        StatusLog.SelText = vbCrLf & "0x31 Received, Pause."

        keybd_event VK_CONTROL, 0, KEYEVENTF_KEYUP, 0   'release keys
        keybd_event VK_ALT, 0, KEYEVENTF_KEYUP, 0
        keybd_event VK_HOME, 0, KEYEVENTF_KEYUP, 0
        
    Case &H32
        keybd_event VK_CONTROL, 0, 0, 0                 'press keys
        keybd_event VK_ALT, 0, 0, 0
        keybd_event VK_PGUP, 0, 0, 0

        StatusLog.SelText = vbCrLf & "0x32 Received, Previous Track."

        keybd_event VK_CONTROL, 0, KEYEVENTF_KEYUP, 0   'release keys
        keybd_event VK_ALT, 0, KEYEVENTF_KEYUP, 0
        keybd_event VK_PGUP, 0, KEYEVENTF_KEYUP, 0

    Case &H33
        keybd_event VK_CONTROL, 0, 0, 0                 'press keys
        keybd_event VK_ALT, 0, 0, 0
        keybd_event VK_PGDOWN, 0, 0, 0

        StatusLog.SelText = vbCrLf & "0x33 Received, Next Track."

        keybd_event VK_CONTROL, 0, KEYEVENTF_KEYUP, 0   'release keys
        keybd_event VK_ALT, 0, KEYEVENTF_KEYUP, 0
        keybd_event VK_PGDOWN, 0, KEYEVENTF_KEYUP, 0
        
    Case &H34

        StatusLog.SelText = vbCrLf & "0x34 Received, Null Command."
        
    Case &H35

        StatusLog.SelText = vbCrLf & "0x35 Received, Null Command."
       
    Case &H36
        keybd_event VK_CONTROL, 0, 0, 0                 'press keys
        keybd_event VK_ALT, 0, 0, 0
        keybd_event VK_UP, 0, 0, 0

        StatusLog.SelText = vbCrLf & "0x36 Received, Volume Up."

        keybd_event VK_CONTROL, 0, KEYEVENTF_KEYUP, 0   'release keys
        keybd_event VK_ALT, 0, KEYEVENTF_KEYUP, 0
        keybd_event VK_UP, 0, KEYEVENTF_KEYUP, 0
        
    Case &H37
        keybd_event VK_CONTROL, 0, 0, 0                 'press keys
        keybd_event VK_ALT, 0, 0, 0
        keybd_event VK_DOWN, 0, 0, 0

        StatusLog.SelText = vbCrLf & "0x37 Received, Volume Down."

        keybd_event VK_CONTROL, 0, KEYEVENTF_KEYUP, 0   'release keys
        keybd_event VK_ALT, 0, KEYEVENTF_KEYUP, 0
        keybd_event VK_DOWN, 0, KEYEVENTF_KEYUP, 0
        
    Case &H38
        keybd_event VK_CONTROL, 0, 0, 0                 'press keys
        keybd_event VK_ALT, 0, 0, 0
        keybd_event VK_END, 0, 0, 0

        StatusLog.SelText = vbCrLf & "0x38 Received, Stop."

        keybd_event VK_CONTROL, 0, KEYEVENTF_KEYUP, 0   'release keys
        keybd_event VK_ALT, 0, KEYEVENTF_KEYUP, 0
        keybd_event VK_END, 0, KEYEVENTF_KEYUP, 0

    End Select
End If
    
End Sub
