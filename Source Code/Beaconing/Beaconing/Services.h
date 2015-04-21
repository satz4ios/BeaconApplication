//
//  Services.h
//  Beaconing
//
//  Created by Madhu.A on 16/03/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//
#include "Services.h"

#ifndef Beaconing_Services_h
#define Beaconing_Services_h

#ifdef PROD
#define Beaconing_API_Endpoint_Host                 @"http://gotocontactsonline.com/beaconapp/"

#elif UAT
#define Beaconing_API_Endpoint_Host                 @"http://gotocontactsonline.com/beaconapp/"

#elif DEV
#define Beaconing_API_Endpoint_Host                 @"http://gotocontactsonline.com/beaconapp/"

#else
#define Beaconing_API_Endpoint_Host                 @"http://gotocontactsonline.com/beaconapp/"

#endif


///Common Services///

#define RegisterUser                     (Beaconing_API_Endpoint_Host @"registration.php");
#define LoginUser                        (Beaconing_API_Endpoint_Host @"login.php");
#define forgotPassword                   (Beaconing_API_Endpoint_Host @"forgetpassword.php");
#define AddOrEditBeacon                  (Beaconing_API_Endpoint_Host @"beaconconfig.php");
#define GetListOfBeacons                 (Beaconing_API_Endpoint_Host @"beacondetails.php");
#define CreateCoupon                     (Beaconing_API_Endpoint_Host @"couponconfig.php");
#define DeleteBeacon                     (Beaconing_API_Endpoint_Host @"deletebeacon.php");
#endif