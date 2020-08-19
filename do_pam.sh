cp /etc/pam.d/system-auth .
cp /etc/pam.d/password-auth .

_Attempts="5"
_Timeout="180"
_RootTimeout="300"


# The auth string to use.
_Auth="\
### START CIS Update ###\n\
auth        required      pam_faillock.so preauth silent audit deny=${_Attempts} even_deny_root unlock_time=180 root_unlock_time=${_RootTimeout}\n\
auth        [default=die] pam_faillock.so authfail audit deny=${_Attempts} unlock_time=${_Timeout}\n\
### END CIS Update ###"

# The account string to use.
_Account="\
### START CIS Update ###\n\
account     required      pam_faillock.so\n\
### END CIS Update ###"


sed -i.sys_bkp  -e '/^\s*auth\s*required\s*pam_deny/ a'"${_Auth}"'' -e '/^\s*account\s*required\s*pam_permit/ a'"${_Account}"'' ./system-auth
sed -i.pass_bkp -e '/^\s*auth\s*required\s*pam_deny/ a'"${_Auth}"'' -e '/^\s*account\s*required\s*pam_permit/ a'"${_Account}"'' ./password-auth

exit


