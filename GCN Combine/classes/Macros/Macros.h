

@class AppDelegate;


extern AppDelegate *gObjAppDelegatePtr;

#ifdef DEBUG
#define DSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DSLog(...)
#endif


#if 0
#define LOGPOSTURL  @"http://api.gamechangernation.com/Service.svc/json/CombineAct"
#define ADDATHURL   @"http://api.gamechangernation.com/Service.svc/json/AthleteAct"
#define DOWNLOADATHLETELISTURL  @"http://api.gamechangernation.com/Service.svc/json/athlete/0/null"
#define DOWNLOADATHLETEDETAILURL @"http://gcn.azaz.com/gcnapi/service.svc/json/AllAthlete/%@/null"
#else
#define LOGPOSTURL  @"http://testgcnapi.rojoli.com/service.svc/json/combineact"
#define ADDATHURL   @"http://testgcnapi.rojoli.com/service.svc/json/AthleteAct"
#define DOWNLOADATHLETELISTURL  @"http://testgcnapi.rojoli.com/Service.svc/json/athlete/0/null"
#define DOWNLOADATHLETEDETAILURL @"http://testgcnapi.rojoli.com/service.svc/json/AllAthlete/%@/null"
#endif
//sougat added this on 12/9/13
#define ADDNEWATHLETEJSONKEY             @"AthleteCombineActionResult"
#define UPLOADLOGJSONKEY                 @"CombineResultNewActionResult"
#define DOWNLOADATHLETEJOSONKEY          @"GCNAthleteCombineResult"
#define DOWNLOADATHLETEJSONDATA          @"AthleteCombineData"
#define DOWNLOADATHLETERESPONSEJSONKEY   @"ResponseCode"
#define DOWNLOADATHLETEDETAILJSONKEY     @"GCNAllAthleteInfoJsonResult"
#define DOWNLOADATHLETDETAILJSONDATKEY   @"AthleteData"
#define COMBINE                          @"CombineData"

 


#define SAFE_RELEASE(MemPtr)				{if(nil != MemPtr) \
                                            [MemPtr release]; \
                                             MemPtr = nil;}

#define SPACING                             5.0
#define HEIGHT                              70
#define ADDATHLETEUPPERTABLE                100
#define ADDATHLETELOWERTABLE                101
#define ADDLOGGERVERTICALJUMPTABLE          102
#define ADDLOGGERZIGZAGTABLE                103
#define ADDLOGGERSPIKESPEEDTALE             104
#define ADDATHLETELOWERTABLE_TESTSET2       105
#define ADDATHLETELOWERTABLE_TESTSET3       106

#define ATHLETEFIRSTNAMETAG                 1
#define ATHLETELASTNAMETAG                  2
#define ATHLETEAGETAG                       3
#define ATHLETEEMAILTAG                     4
#define ATHLETEPHONETAG                     5
#define ATHLETEADDRESSTAG                   6
#define ATHLETESCHOOLTAG                    60
#define ATHLETETEAMTAG                      61
#define ATHLETEYEARTAG                      62
#define ATHLETESPORTSTAG                    63
#define ATHLETEPUSHUPTAG                    64
#define ATHLETEVERTICALTAG                  65
#define ATHLETEPOSITIONTAG                  66
#define ATHLETECITYTAG                      67
#define ATHLETESTATETAG                     68
#define ATHLETEPASSINGACCURACYTAG           69
#define ATHLETESERVEACCURACYTAG             70

#define ATHLETEVERTICALJUMPTRIAL1           71
#define ATHLETEVERTICALJUMPTRIAL2           72
#define ATHLETEVERTICALJUMPTRIAL3           73
#define ATHLETESPIKESPEED1                  74
#define ATHLETESPIKESPEED2                  75
#define ATHLETESPIKESPEED3                  76

#define ATHLETEZIGZAGTAG1                   77
#define ATHLETEZIGZAGTAG2                   78
#define ATHLETEZIPTAG                       79
#define ATHLETETYPETAG                      80
#define ATHLETENICKNAMETAG                  81
#define ATHLETEEMAILPASSWORDTAG             82
#define ATHLETECELLPHONETAG                 83
#define ATHLETEFBIDTAG                      84
#define ATHLETETWITIDTAG                    85
#define ATHLETEPERSONALINFOTAG              86
#define ATHLETESCHOOLCOACHNAMETAG           87
#define ATHLETECLUBCOACHNAMETAG             88
#define ATHLETEREACHTAG                     89
#define ATHLETEHEIGHTTAG                    90
#define ATHLETEWEIGHTTAG                    91
#define ATHLETEWINGSPANTAG                  92
#define ATHLETESHOESIZETAG                  93
#define ATHLETEUIDTAG                       94
#define ATHLETEACTIVETAG                    95
#define ATHLETETSTAG                        96
#define ATHLETEADDPICKERTAG                 97
#define ATHLETEADDDOBPICKERTAG              98
#define ATHLETE_GENDER_TAG                  99
#define ATHLETE_GENDER_PICKERVIEW_TAG       1000
#define ATHLETE_GENDER_PICKER_FOREDT        1001
#define MIN_TXTFIELD_TAG                    1002
#define SEC_TXTFIELD_TAG                    1002


#define COMBINETEXTFIELDTAG                 200

#define STANDARD_BUTTON_DIMENSION           44.0
#define ATTACHMENT_ORIGIN_Y                 CGRectGetHeight(m_cApplicationSize) - \
                             CGRectGetHeight(self.navigationController.navigationBar.frame)- \
ATTACHMENT_DIMENSION - SPACING *7.0
#define ATTACHMENT_ORIGIN_X      (CGRectGetWidth(m_cApplicationSize)/2.0 - (SPACING))

#define ATTACHMENT_DIMENSION     (CGRectGetWidth(m_cApplicationSize) - ATTACHMENT_ORIGIN_X - SPACING)

#define ATTACHMENT_ORIGIN_Y        CGRectGetHeight(m_cApplicationSize) - \
                               CGRectGetHeight(self.navigationController.navigationBar.frame)- \
ATTACHMENT_DIMENSION - SPACING *7.0
#define GET_SPACE(pVal)						(pVal != nil ? @" " : @"")
#define GET_STR(pVal)						(pVal != nil ? pVal : @"")
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
                                             colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                              green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                              blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define SAFE_CFRELEASE(pDataPtr)			if(NULL != pDataPtr)\
                                            {\
                                                CFRelease((CFStringRef)pDataPtr);\
                                                pDataPtr = NULL;\
                                            }

#define IFT_ETHER                               0x6
#define MAC_ADRS_LENGTH                         50

typedef enum
{
	PushUp = 0,
	VerticalJump,
	CourtSprints,
    ZigZag,
    SettingAccuracy,
    SpikeSpeed,
    PassingAccuracy,
    ServeAccuracy,
    ApproachJump,
    BroadJump,
    ServeSpeed,
    StandingVertical
} LogDisplayMode;


typedef enum
{
	Login = 0,
    Upload,
    updateAthlet,
    DownloadAthleteDetail,
    uploadPhoto,
    Uploadlog,
    Download,
    CombineID,
    CombineTests,
    UploadPendingImage
} ServerTransMode;
