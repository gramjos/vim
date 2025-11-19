"""
Generates ASCII art bubble letters.
The character map is stored directly in this script using raw, multi-line
strings to avoid the need for escaping backslashes or managing external files.
"""

# The ASCII art map is now a Python dictionary.
# Using raw, triple-quoted strings (r"""...""") means you can paste
# the art directly without worrying about escaping backslashes.
BUBBLE_MAP = {
  "a": r"""
   __ _     
  / _` |    
 | (_| |    
  \__,_|    
""",
  "b": r"""
  _         
 | |__      
 | '_ \     
 | |_) |    
 |_.__/     
""",
  "c": r"""
   ___      
  / __|     
 | (__      
  \___|     
""",
  "d": r"""
      _     
   __| |    
  / _` |    
 | (_| |    
  \__,_|    
""",
  "e": r"""
   ___      
  / _ \     
 |  __/     
  \___|     
""",
  "f": r"""
   __       
  / _|      
 | |_       
 |  _|      
 |_|        
""",
  "g": r"""
   __ _     
  / _` |    
 | (_| |    
  \__, |    
  |___/     
""",
  "h": r"""
  _         
 | |__      
 | '_ \     
 | | | |    
 |_| |_|    
""",
  "i": r"""
  _         
 (_)        
 | |        
 | |        
 |_|        
""",
  "j": r"""
    _       
   (_)      
   | |      
   | |      
  _/ |      
 |__/       
""",
  "k": r"""
  _         
 | | __     
 | |/ /     
 |   <      
 |_|\_\     
""",
  "l": r"""
  _         
 | |        
 | |        
 | |        
 |_|        
""",
  "m": r"""
  _ __ ___  
 | '_ ` _  \
 | | | | | |
 |_| |_| |_|
""",
  "n": r"""
  _ __      
 | '_ \     
 | | | |    
 |_| |_|    
""",
  "o": r"""
   ___      
  / _ \     
 | (_) |    
  \___/     
""",
  "p": r"""
  _ __      
 | '_ \     
 | |_) |    
 | .__/     
 |_|        
""",
  "q": r"""
   __ _     
  / _` |    
 | (_| |    
  \__, |    
     |_|    
""",
  "r": r"""
  _ __      
 | '__|     
 | |        
 |_|        
""",
  "s": r"""
  ___       
 / __|      
 \__ \      
 |___/      
""",
  "t": r"""
  _         
 | |_       
 | __|      
 | |_       
  \__|      
""",
  "u": r"""
  _   _     
 | | | |    
 | |_| |    
  \__,_|    
""",
  "v": r"""
 __   __    
 \ \ / /    
  \ V /     
   \_/      
""",
  "w": r"""
 __      __ 
 \ \ /\ / / 
  \ V  V /  
   \_/\_/   
""",
  "x": r"""
 __  __     
 \ \/ /     
  >  <      
 /_/\_\     
""",
  "y": r"""
  _   _     
 | | | |    
 | |_| |    
  \__, |    
  |___/     
""",
  "z": r"""
  ____      
 |_  /      
  / /       
 /___|      
""",
  " ": r"""




"""
}
