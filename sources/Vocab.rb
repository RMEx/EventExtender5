#==============================================================================
# ** Vocab
#------------------------------------------------------------------------------
#  This module defines terms and messages. It defines some data as constant
# variables.
#==============================================================================

module Vocab
  #--------------------------------------------------------------------------
  # * Singleton
  #--------------------------------------------------------------------------
  class << self
    #--------------------------------------------------------------------------
    # * Text description
    #--------------------------------------------------------------------------
    def tone_manager;   "Testeur de teintes";                     end
    def tone_wait;      "Attendre la fin?";                       end
    def tone_duration;  "Durée en frames?";                       end
    def tone_try;       "Test Transition";                        end
    def tone_generate;  "Générer";                                end
    def tone_copied;    "Teinte dans le presse papier";           end
    def eval_ingame;    "Tester une ligne Ruby";                  end
    def eval_run;       "Tester" ;                                end
    def eval_make;      "Copier";                                 end
    def eval_copied;    "Appel de script dans le presse papier";  end
    def eval_error;     "Il y a une erreur dans la ligne !";      end
    def table_list;     "Liste des tables";                       end
    def table_error;    "Nombre de champs incorrect";             end
    def table_empty;    "Il n'y a aucune table";                  end
    def table_add(t);   "Ajouter une entrée dans #{t.to_s}";      end
    def table_saved;    "Enregistrement sauvé";                   end
    def entries(size);   (size == 0) ? "entrée" : "entrées";      end
    def empty;          "Vider";                                  end
    def add_row;        "Insérer";                                end
    def warning;        "Attention";                              end
    def save;           "Sauver";                                 end
    def quit;           "Quitter";                                end
    def erase_selection;"Supprimer la sélection";                 end
    def erase_elt;      "Supprimer l'entrée";                     end
    def save_edit;      "Sauvegarder la modification";            end
    def exit;           "Quitter";                                end
    def extend_db;      "Gestion de la Base de données avancée";  end
    def manager;        "Manageurs";                              end
    def generate_cmd;   "Générer une commande";                   end
    def generate_event; "Générer un évènement";                   end
    def exp_event;      "Exporter un évènement";                  end
    def imp_event;      "Importer un évènement";                  end
    def scene_builder;  "Créer/Editer une scène";                 end
    def sbs_lab;        "Laboratoire de SBS";                     end
    def skip_title;     "Tueur d'écran titre";                    end
    def chose_map_start;"Choisissez une map de départ";           end
    def chose_sq_start; "Cliquez sur la case de départ";          end
    def preserve_title; "Ne pas sauter le titre";                 end
    def modif_ok;       "Les modifications ont été sauvées";      end
    def command_list;   "Liste des commandes";                    end
    def cat_list;       "Catégories des commandes";               end
    def no_cat;         "Non triées";                             end
    def commons_ev;     "Evénements communs";                     end
    def battle_ev;      "Evénements de combat";                   end
    def map_ev;         "Evénements sur une carte";               end
    def no_title;       "Pas de titre";                           end
    def gen_common;     "Générer l'évènement commun %03d";        end
    def in_html;        "En HTML";                                end
    def in_bbcode;      "En BBCode";                              end
    def in_code;        "En code importable";                     end
    def create_command(m="") 
      "Créer la commande #{m.to_s}"
    end
    def table_entries(t)
      "Entrées de #{t.to_s}";      
    end
    def table_not_uniq
      "Il existe déjà un champ qui à cette clé primaire" 
    end
    def table_add_quit
      m = "Si vous quittez, cet enregistrement ne sera pas sauvé"
      m.to_ascii
    end
    def empty_db(table)     
      m = "Cette opération est irréversible." <<
      "\nDésirez-vous vraiment vider la table #{table}"
      m.to_ascii 
    end
    def empty_selection(table, len  = 1)     
      m = "Cette opération est irréversible." <<
      "\nDésirez-vous vraiment supprimer #{(len > 1)? "les #{len} enregistrements": "l'enregistremment"} de  #{table}"
      m.to_ascii 
    end
    def method_missing(args, keywords)
      snd = keywords.length > 1 ? " ou \"#{keywords[1]}\"" : ""
      "#{args[0]} n'existe pas, vouliez vous dire \"#{keywords[0]}\""+snd+"?"
    end
  end
end