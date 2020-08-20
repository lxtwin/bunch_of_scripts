cp /etc/pam.d/system-auth .
cp /etc/pam.d/password-auth .

_Attempts="5"
_Timeout="180"
_RootTimeout="300"


# The auth string to use.
_Auth1="\
### CIS Update 1 ###\n\
auth        required      pam_faillock.so preauth silent audit deny=${_Attempts} even_deny_root unlock_time=180 root_unlock_time=${_RootTimeout}"

_Auth2="\
### CIS Update 2 ###\n\
auth        [default=die] pam_faillock.so authfail audit deny=${_Attempts} unlock_time=${_Timeout}"

# The account string to use.
_Account="\
### CIS Update 3 ###\n\
account     required      pam_faillock.so"


sed -i.sys_bkp  -e '/^\s*auth\s*required\s*pam_env.so/ a'"${_Auth1}"'' \
                -e '/^\s*auth\s*sufficient\s*pam_unix.so/ a'"${_Auth2}"'' \
                -e '/^\s*account\s*required\s*pam_unix.so/ i'"${_Account}"'' ./system-auth


sed -i.pass_bkp -e '/^\s*auth\s*required\s*pam_env.so/ a'"${_Auth1}"'' \
                -e '/^\s*auth\s*sufficient\s*pam_unix.so/ a'"${_Auth2}"'' \
                -e '/^\s*account\s*required\s*pam_unix.so/ i'"${_Account}"'' ./password-auth

exit
