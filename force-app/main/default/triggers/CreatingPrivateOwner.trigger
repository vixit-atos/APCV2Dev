trigger CreatingPrivateOwner on Account (after Insert,After Update) {
      if(Trigger.IsAfter && Trigger.isInsert){
            CreatingPrivateOwnerHandler.CreatingPrivateOwner(Trigger.new);
   }
}