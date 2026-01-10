import { createContext, useContext, useState, useEffect, ReactNode } from "react";

type SelectedPropertyContextType = {
    selectedPropertyId: string | null;
    setSelectedPropertyId: (id: string | null) => void;
    isLoading: boolean;
};

const SelectedPropertyContext = createContext<SelectedPropertyContextType | undefined>(undefined);

export function SelectedPropertyProvider({ children }: { children: ReactNode }) {
    const [selectedPropertyId, setSelectedPropertyId] = useState<string | null>(() => {
        return localStorage.getItem("selectedPropertyId");
    });
    const [isLoading, setIsLoading] = useState(false);

    useEffect(() => {
        if (selectedPropertyId) {
            localStorage.setItem("selectedPropertyId", selectedPropertyId);
        } else {
            localStorage.removeItem("selectedPropertyId");
        }
    }, [selectedPropertyId]);

    return (
        <SelectedPropertyContext.Provider value={{ selectedPropertyId, setSelectedPropertyId, isLoading }}>
            {children}
        </SelectedPropertyContext.Provider>
    );
}

export function useSelectedProperty() {
    const context = useContext(SelectedPropertyContext);
    if (context === undefined) {
        throw new Error("useSelectedProperty must be used within a SelectedPropertyProvider");
    }
    return context;
}
