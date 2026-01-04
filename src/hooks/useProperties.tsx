import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { Tables } from "@/integrations/supabase/types";

export type Property = Tables<"properties">;

export const useProperties = () => {
    const { data: properties, isLoading, error } = useQuery({
        queryKey: ["properties"],
        queryFn: async () => {
            console.log("[useProperties] Fetching properties...");
            const { data, error } = await supabase
                .from("properties")
                .select("*")
                .order("name");

            if (error) {
                console.error("[useProperties] Error fetching properties:", error);
                throw error;
            }

            return data as Property[];
        },
    });

    return {
        properties: properties || [],
        isLoading,
        error,
    };
};
