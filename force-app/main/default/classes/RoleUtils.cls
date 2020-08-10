public with sharing class RoleUtils {

    public static Set<ID> getRoleSubordinateUsers(Id roleId) {
     
        // get all of the roles underneath the user
        Set<Id> allSubRoleIds = getSubordinateRoles(roleId);
        // get all of the ids for the users in those roles
        Map<Id,User> users = new Map<Id, User>([Select Id, Name From User where 
                                                UserRoleId IN :allSubRoleIds]);     
        // return the ids as a set so you can do what you want with them
        return users.keySet();
    }
    
    // get the user roles list and format with parent, child relationship
    public static set<Id> getSubordinateRoles(Id roleId) {
        map<Id, set<Id>> parentAndChildren = new map<Id, set<Id>>();
        set<Id> children;
        List<UserRole> lstuserRoles = [select Id, ParentRoleId from UserRole where ParentRoleID != null];
        for(UserRole ur : lstuserRoles) {
                children = parentAndChildren.containsKey(ur.ParentRoleId) ? parentAndChildren.get(ur.ParentRoleId) : new set<Id>();
                children.add(ur.Id);
                parentAndChildren.put(ur.ParentRoleId, children);
		}
        return getSubordinateRoles(roleId, parentAndChildren);
    }
    
    //get the user roles for the given roleID
    public static set<Id> getSubordinateRoles(Id roleId, map<Id, set<Id>> parentAndChildren) {
        set<Id> subordinateRoles = new set<Id>();
        set<Id> remainingSubordinateRoles = new set<Id>();
        if(parentAndChildren.containsKey(roleId)) {
            subordinateRoles.addAll(parentAndChildren.get(roleId));
            for(Id subRoleId : subordinateRoles) {
                    remainingSubordinateRoles.addAll(getSubordinateRoles(subRoleId, parentAndChildren));
            }
        }
        subordinateRoles.addAll(remainingSubordinateRoles);
        return subordinateRoles;
    }
   

}